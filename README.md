# search-nicovideo-rb

This is a client library for [niconico search API](http://search.nicovideo.jp/docs/api/snapshot.html).
[ニコニココンテンツ検索API](http://search.nicovideo.jp/docs/api/snapshot.html) を使うためのライブラリ 

# How to use

```ruby
require 'nicosearch'
qb = SearchNicovideo::QueryBuilder.new()
q = qb.query("test").service(["video"]).targets(["title","description"])
    .fields(["title","description", "contentId"])
    .size(10).from(0)
    .filters(filters).sort("startTime").build
SearchNicovideo::search(q)
```
