# alite [![Build Status](https://secure.travis-ci.org/toyama0919/alite.png?branch=master)](http://travis-ci.org/toyama0919/alite)

Tool to generate json for alfred workfow's script filter from sqlite3.

## Settings Examples(Normal Mode)

$HOME/.alite

```yaml
search_logs:
  database: '<%=ENV['HOME'] %>/.sqlite/suggest.db'
  table_name: search_logs
  title_key: keyword
  subtitle_key: created_at
  arg_key: keyword
  where_match_columns:
    - keyword
  order: "created_at"
  initial_limit: 200
```

## Settings Examples(SQL Mode)

1. Be sure to write WHERE!
2. Also, to rename the column names in the output using as.
  * title
  * subtitle
  * arg

```yaml
search_logs:
  adapter: sqlite3
  database: '<%=ENV['HOME'] %>/.sqlite/suggest.db'
  where_match_columns:
    - keyword
  sql: |
    select
      keyword as title,
      created_at as subtitle,
      keyword as arg
    from search_logs
    where
      1 = 1
    order by updated_at desc
    limit 100
```

### execute

```bash
$ alite -s -w amazon -p search_logs | jq .
{
  "items": [
    {
      "title": "amazon",
      "subtitle": "2023-01-03 12:07:16.956710",
      "arg": "amazon",
      "valid": true,
      "autocomplete": "amazon"
    },
    {
      "title": "amazon ring doorbell 4",
      "subtitle": "2023-01-02 01:49:35.937582",
      "arg": "amazon ring doorbell 4",
      "valid": true,
      "autocomplete": "amazon ring doorbell 4"
    },
...
```

## Ruby API

If you run the following code, alfred json will be output, so you can use it in script filter.

```ruby
require "alite"
require "json"

puts Alite.suggest(ARGV[0], profile: "search_logs").to_json
```

## Installation

Add this line to your application's Gemfile:

    gem 'alite'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alite

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Information

* [Homepage](https://github.com/toyama0919/alite)
* [Issues](https://github.com/toyama0919/alite/issues)
* [Documentation](http://rubydoc.info/gems/alite/frames)
* [Email](mailto:toyama0919@gmail.com)

## Copyright

Copyright (c) 2018 Hiroshi Toyama

See [LICENSE.txt](../LICENSE.txt) for details.
