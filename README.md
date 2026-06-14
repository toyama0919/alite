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

## CLI Options

```bash
$ alite -s -w <query> [options]
```

| Option | Alias | Type | Default | Description |
| --- | --- | --- | --- | --- |
| `--query` | `-w` | string | (required) | Search query. Space-separated words are AND-matched against `where_match_columns`. |
| `--arg_vars` | `-a` | hash | none | Variables to interpolate into `arg`. `${name}` placeholders in the row's `arg` are replaced (e.g. `-a id:123 name:value`). Unmatched placeholders are left as-is. |
| `--config` | `-c` | string | `$HOME/.alite` | Path to the YAML config file. |
| `--profile` | `-p` | string | `default` | Profile (top-level key) to read from the config file. |
| `--verbose` | `-V` | boolean | `false` | Print the generated config and SQL to stderr for debugging. |
| `-s` | | | | Run the `script_filter` command (outputs Alfred JSON). |

## Configuration Options

The config file is YAML and is evaluated through ERB first, so you can embed Ruby
(e.g. `<%=ENV['HOME'] %>`). Each top-level key is a profile selected with `-p`.

### Common options (both modes)

| Key | Required | Default | Description |
| --- | --- | --- | --- |
| `database` | yes | | Path to the SQLite3 database file. |
| `where_match_columns` | yes | | Columns matched with `LIKE '%word%'` for each word in the query. |
| `uid` | no | none | When truthy, set the Alfred item `uid` to the row's `arg` (lets Alfred learn/sort by usage). |
| `immutable` | no | `false` | Open the DB read-only via the `immutable=1` URI. Takes no lock, so a DB being written to (e.g. a running Chrome `History`) can be read directly without copying. |

### Normal Mode options

alite builds the SQL for you from these keys.

| Key | Required | Default | Description |
| --- | --- | --- | --- |
| `table_name` | yes | | Table to query. |
| `title_key` | yes | | Column used as the item `title`. |
| `subtitle_key` | no | empty | Column used as the item `subtitle`. |
| `arg_key` | no | | Column used as the item `arg`. |
| `where_base` | no | `1 = 1` | Extra WHERE condition AND-ed with the query match (e.g. `deleted = 0`). |
| `order` | no | none | Column to `ORDER BY ... DESC`. |
| `initial_limit` | no | `20` | `LIMIT` applied to the query. |

### SQL Mode options

Write the full SQL yourself. Note:

1. You **must** include a `WHERE` clause — the query match is injected right after the `where` keyword.
2. Alias output columns to `title`, `subtitle`, and `arg` with `as`.

| Key | Required | Default | Description |
| --- | --- | --- | --- |
| `sql` | yes | | The SQL statement to run. The word-match condition is inserted just after `where`. |
| `adapter` | no | | Adapter name (informational; only `sqlite3` is supported). |

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
