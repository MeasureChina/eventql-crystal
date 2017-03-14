[![Build Status](https://travis-ci.org/MeasureChina/eventql-crystal.svg?branch=master)](https://travis-ci.org/MeasureChina/eventql-crystal)

# eventql-crystal

EventQL driver for Crystal ([eventql.io](http://eventql.io))


Based on the official ruby driver  
https://github.com/eventql/eventql/tree/master/drivers/ruby


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  eventql-crystal:
    github: measurechina/eventql-crystal
```


## Usage

```crystal
require "eventql-crystal"

# init
client = EventQL.connect({
  "host" => "localhost",
  "port" => "9175",
  "database" => "sensors",
})

# insert rows
body = [
  {
    database: "test",
    table: "sensors",
    data: {
      time: Time.now.to_utc.to_s("%FT%XZ"),
      session_id: "s1",
      url: "/page1",
    }
  }
].to_json

result = client.insert!(body)

# query
query = client.query("SELECT COUNT(1) FROM sensors;")
response = query.execute!

# [{"type" => "table", "columns" => ["COUNT(1)"], "rows" => [["1"]]}]

query = client.query("SELECT * FROM sensors;")
response = query.execute!


```


## TODO:
  - [ ] table create/drop/list
  - [ ] table add_field/remove_field
  - [ ] Time conversion util
  - [ ] time zone util
  - [ ] MapReduce query
  - [ ] json mapping helper


## Contributing

1. Fork it ( https://github.com/measurechina/eventql-crystal/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
