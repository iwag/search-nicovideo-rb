require 'net/http'
require 'json'
require 'date'

module SearchNicovideo
  extend self

  def uri_string
    'http://search.nicovideo.jp/api/'
  end

  def uri
    URI.parse(uri_string)
  end

  def snapshot_uri_string
    'http://search.nicovideo.jp/api/snapshot/'
  end

  def snapshot_uri
    URI.parse(snapshot_uri_string)
  end

  def watch_uri(s,id)
    URI.parse("http://#{s}.nicovideo.jp/watch/#{id}")
  end

  def search_raw(q)
    res = nil
    uri = uri()
    Net::HTTP.start(uri.host, uri.port){|http|
      res = http.post(uri.path, q)
    }
    res
  end

  def search(q) # q must be JSON
    res = search_raw(q)
    arr = res.body.split("\n").map{|i| JSON.parse(i) }
    hits = arr.select{ |i| i["type"]=="hits" && ! i["endofstream"] }
    stats = arr.select{ |i| i["type"]=="stats" && ! i["endofstream"] }
    {
      stats: stats,
      hits: hits
    }
  end

  def parse_time(s)
    return nil if !s.is_a?(String)
    DateTime.parse(s + "+9:00").to_time # dirty hack
  end

  class QueryBuilder
    def  initialize()
      @q = {query: "test", service: ["video"], search: ["title", "description"], join: ["title"], issuer: "http://github.com/iwag/search-nicovideo-rb", reason:"ma10"}
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

    def search(s)
      if s.is_a?(Array)
        @q[:search] = s
      end
      self
    end

    def join(j)
      if j.is_a?(Array)
        @q[:join] = j
      end
      self
    end

    def issuer(s)
      if s.is_a?(String)
        @q[:issuer] = s
      end
      self
    end

    def sort_by(s)
      if s.is_a?(String)
        @q[:sort_by] = s
      end
      self
    end

    def desc(d)
      if d==true
        @q[:order] = "desc"
      else
        @q[:order] = "asc"
      end
      self
    end

    def filters(f)
      @q[:filters] = f
      self
    end

    def build
      @q
    end

    def to_json
      @q.to_json
    end
  end

  class FilterBuilder
    def initialize()
      @f = { }
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
      @f
    end

    def to_json
      @f.to_json
    end
  end

end 
