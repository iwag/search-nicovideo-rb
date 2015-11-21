require 'net/http'
require 'json'
require 'date'

module SearchNicovideo
  extend self

  def search(u)
    encoded = URI.encode(u)
    uri = URI.parse(encoded)
    res = Net::HTTP.get(uri)
    JSON.parse(res)
  end

  def parse_time(s)
    return nil if !s.is_a?(String)
    DateTime.parse(s + "+9:00").to_time # dirty hack
  end

  class QueryBuilder
    def uri_string
      'http://search.nicovideo.jp/api/v2'
    end

    def  initialize()
      @q = {query: "test", service: ["video"], target: ["title", "description"], fields: ["title"], issuer: "github.com/iwag/search-nicovideo-rb", reason:"ma10"}
    end

    def query(s)
      @q[:query] = s
      self
    end

    def service(s)
      if s.is_a?(Array)
        @q[:service] = s
      end
      self
    end

    def targets(s)
      if s.is_a?(Array)
        @q[:targets] = s
      end
      self
    end

    def fields(j)
      if j.is_a?(Array)
        @q[:fields] = j
      end
      self
    end

    def issuer(s)
      if s.is_a?(String)
        @q[:issuer] = s
      end
      self
    end

    def sort(s)
      if s.is_a?(String)
        @q[:sort] = s
      end
      self
    end

    def filters(f)
      raise "#{f} not array" if !f.is_a?(Array)
      @q[:filters] = f
      self
    end

    def size(i)
      @q[:size] = i
      self
    end

    def from(i)
      @q[:from] = i
      self
    end

    def build
      uri_string + "/#{@q[:service][0]}/contents/search?" + 
      [
        "q=#{@q[:query]}",
        "targets=#{@q[:targets].join(",")}",
        "fields=#{@q[:fields].join(",")}",
        "_sort=#{@q[:sort]}",
        "_limit=#{@q[:size]}",
        "_offset=#{@q[:from]}",
        "_context=#{@q[:issuer]}"
      ].join("&")
    end
  end

  class FilterBuilder
    def initialize()
      @f = { }
    end

    def range(f, from, to)
      @f[:type] = "range"
      @f[:field] = f
      @f[:from] = from
      @f[:to] = to
      self
    end

    def equal(f, v)
      @f[:type] = "equal"
      @f[:field] = f
      @f[:value] = v
      self
    end

    def type(t)
      @f[:type] = t
      self
    end

    def field(f)
      @f[:field] = f
      self
    end

    def value(v)
      @f[:value] = v
      self
    end

    def from(v) 
      @f[:from] = v
      self
    end

    def to(v)
      @f[:to] = v
      self
    end
      
    def build
      q = if @f[:type] == "equal"
        "filters[#{@f[:field]}][0]=#{@f[:value]}"
      elsif @f[:type] == "range"
        [
          "filters[#{@f[:field]}][gte]=#{@f[:from]}",
          "filters[#{@f[:field]}][lte]=#{@f[:to]}"
        ].join("=")
      else
        ""
      end
      q
    end
  end

end 
