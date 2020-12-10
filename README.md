# alite [![Build Status](https://secure.travis-ci.org/toyama0919/alite.png?branch=master)](http://travis-ci.org/toyama0919/alite)

alfred workfowのscript filterのjsonをsqlite3から生成するtoolです。

## Settings Examples

$HOME/.alite

```yaml
search_logs:
  database: '<%=ENV['HOME'] %>/.sqlite/suggest.db'
  table_name: search_logs
  title_key: keyword
  subtitle_key: keyword
  output_key: keyword
  columns:
    - keyword
  order: "created_at"
  initial_limit: 200
```

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
