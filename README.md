# search-nicovideo-rb

[ニコニココンテンツ検索API](http://search.nicovideo.jp/docs/api/search.html) を使うためのライブラリ 

# 使い方

```ruby
require 'nicosearch'
qb = SearchNicovideo::QueryBuilder.new()
q = qb.query("test").service(["video"]).targets(["title","description"])
    .fields(["title","description", "contentId"])
    .size(10).from(0)
    .filters(filters).sort("startTime").build
SearchNicovideo::search(q)
```
