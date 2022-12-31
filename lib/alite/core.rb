# frozen_string_literal: true

require 'logger'
require 'sqlite3'
require 'string/scrub' if RUBY_VERSION.to_f < 2.1

module Alite
  class Core
    def initialize(config)
      @logger = Logger.new(STDOUT)
      @config = config
      @db = ::SQLite3::Database.new @config['database']
      @where_match_columns = config['where_match_columns']
      @order = @config['order']
      @where_base = @config['where_base']
      @initial_limit = @config['initial_limit'] || DEFAULT_INITIAL_LIMIT
      @table_name = @config['table_name']
      @uid = @config['uid']

      @title_key = @config['title_key']
      @subtitle_key = @config['subtitle_key']
      @arg_key = @config['arg_key']
    end

    def make_script_filter(words)
      array = []
      @db.prepare(make_sql(words)).execute.each_hash do |row|
        array.push row
      end
      convert(array)
    end

    private

    def make_sql(words)
      sql = %(
        select
          distinct
          #{@config['title_key']} as title,
          #{@config['subtitle_key']} as subtitle,
          #{@config['arg_key']} as arg
        from
          #{@config['table_name']}
      )

      wheres = []
      words.split(' ').each do |word|
        where = @where_match_columns.map { |column| "(#{column} like '%#{word}%')" }.join(' or ')
        where = "(#{where})"
        wheres.push(where)
      end
      wheres << wheres.join(' and ').to_s unless words.empty?
      wheres << "(#{@where_base})" if @where_base
      sql += " where #{wheres.join(' and ')}" unless wheres.empty?
      sql += " order by `#{@order}` desc" if @order
      sql += " limit #{@initial_limit}" if words.empty?
      sql
    end

    def convert(results)
      items = []
      results.each do |result|
        item = {}

        title = result["title"].force_encoding('UTF-8').scrub
        subtitle = ''
        if result["subtitle"]
          subtitle = result["subtitle"].force_encoding('UTF-8').scrub
        end
        arg = result["arg"].to_s.force_encoding('UTF-8').scrub

        item['title'] = title
        item['subtitle'] = subtitle
        item['arg'] = arg
        item['uid'] = arg if @uid
        item['valid'] = true
        item['autocomplete'] = title
        items << item
      end
      { items: items }
    end
  end
end
