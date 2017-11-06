# search-nicovideo-rb

This is a ruby client library for niconico search API v2. 

## API documentation
* [unofficial API document(English)](https://iwag.github.io/search-nicovideo-rb/search_api.html)
* [niconico search API(Jpanase)](http://search.nicovideo.jp/docs/api/snapshot.html)

# How to use

```ruby
require 'nicosearch'
qb = SearchNicovideo::QueryBuilder.new()
q = qb.query("test").service(["video"]).targets(["title","description"])
    .fields(["title","description", "contentId"])
    .size(10).from(0)
    .filters(filters).sort("startTime").build

puts SearchNicovideo::search(q)
```
