# frozen_string_literal: true

require 'logger'
require 'sqlite3'

module Alite
  class Core
    def initialize(config, verbose = false)
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

    def make_script_filter(query, arg_vars = nil)
      sql = make_sql(query)
      @logger.debug(@config)
      @logger.debug(sql)

      items = []
      @db.prepare(sql).execute.each_hash do |row|
        items << convert_row(row, arg_vars)
      end

      { items: items }
    end

    private

    def get_logger(verbose = false)
      logger = Logger.new($stderr)
      logger.level = verbose ? Logger::DEBUG : Logger::INFO
      logger
    end

    def make_sql(query)
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
        make_where_match_query(query),
        @where_base ? "(#{@where_base})" : '1 = 1'
      ]
      where_query = wheres.compact.join(' and ')
      sql += " where #{where_query}"
      sql += " order by `#{@order}` desc" if @order
      sql += " limit #{@initial_limit}"
      sql
    end

    def make_where_match_query(query)
      return nil if query.empty?

      wheres = []
      query.split.each do |word|
        where = @where_match_columns.map { |column| "(#{column} like '%#{word}%')" }.join(' or ')
        where = "(#{where})"
        wheres.push(where)
      end
      wheres.join(' and ').to_s
    end

    def convert_row(result, arg_vars = nil)
      title = result['title'].dup.force_encoding('UTF-8').scrub
      subtitle = ''
      subtitle = result['subtitle'].dup.force_encoding('UTF-8').scrub if result['subtitle']
      arg = build_arg(result, arg_vars)

      item = {
        'title' => title,
        'subtitle' => subtitle,
        'arg' => arg,
        'valid' => true,
        'autocomplete' => result['autocomplete'] || title
      }
      item['uid'] = arg if @uid
      item
    end

    def build_arg(result, arg_vars = nil)
      arg = result['arg'].to_s.dup.force_encoding('UTF-8').scrub

      if arg_vars
        # argに含まれる${変数名}を、arg_varsで指定された値で置換
        arg.gsub(/\$\{(\w+)\}/) do
          key = Regexp.last_match(1)
          arg_vars[key] || arg_vars[key.to_sym] || "${#{key}}"
        end
      else
        # 従来通り arg の値をそのまま返す
        arg
      end
    end
  end
end
