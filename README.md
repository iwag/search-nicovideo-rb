# search-nicovideo-rb

This is a client library for [niconico search API](http://search.nicovideo.jp/docs/api/snapshot.html) in Ruby.

[unofficial API document](./search_api.html) might be helpful.

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
