# frozen_string_literal: true

require 'logger'
require 'sqlite3'
require 'string/scrub' if RUBY_VERSION.to_f < 2.1

module Alite
  class Core
    def initialize(config, verbose=false)
      @logger = get_logger(verbose)
      @config = config
      @db = ::SQLite3::Database.new @config['database']
      @table_name = @config['table_name']
      @where_match_columns = config['where_match_columns']
      @title_key = @config['title_key']
      @subtitle_key = @config['subtitle_key']
      @arg_key = @config['arg_key']

      # optional
      @where_base = @config['where_base']
      @order = @config['order']
      @initial_limit = @config['initial_limit'] || DEFAULT_INITIAL_LIMIT
      @uid = @config['uid']
    end

    def make_script_filter(words)
      array = []
      sql = make_sql(words)
      @logger.debug(@config)
      @logger.debug(sql)
      @db.prepare(sql).execute.each_hash do |row|
        array.push row
      end
      convert(array)
    end

    private

    def get_logger(verbose=false)
      logger = Logger.new(STDERR)
      logger.level = verbose ? Logger::DEBUG : Logger::INFO
      return logger
    end

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

      wheres = [
        make_where_match_query(words),
        @where_base ? "(#{@where_base})" : "1 = 1",
      ]
      where_query = wheres.compact.join(' and ')
      sql += " where #{where_query}"
      sql += " order by `#{@order}` desc" if @order
      sql += " limit #{@initial_limit}"
      sql
    end

    def make_where_match_query(words)
      return nil if words.empty?
      wheres = []
      words.split.each do |word|
        where = @where_match_columns.map { |column| "(#{column} like '%#{word}%')" }.join(' or ')
        where = "(#{where})"
        wheres.push(where)
      end
      wheres.join(' and ').to_s
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
        item['autocomplete'] = result["autocomplete"] ? result["autocomplete"] : title
        items << item
      end
      { items: items }
    end
  end
end
