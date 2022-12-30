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
      @columns = config['columns']
      @order = @config['order']
      @where = @config['where']
      @initial_limit = @config['initial_limit'] || DEFAULT_INITIAL_LIMIT
      @table_name = @config['table_name']
      @uid = @config['uid']

      @title_key = @config['title_key']
      @subtitle_key = @config['subtitle_key']
      @output_key = @config['output_key']
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
          #{@config['title_key']},
          #{@config['subtitle_key']},
          #{@config['output_key']}
        from
          #{@config['table_name']}
      )

      wheres = []
      words.split(' ').each do |word|
        where = @columns.map { |column| "(#{column} like '%#{word}%')" }.join(' or ')
        where = "(#{where})"
        wheres.push(where)
      end
      wheres << wheres.join(' and ').to_s unless words.empty?
      wheres << "(#{@where})" if @where
      sql += " where #{wheres.join(' and ')}" unless wheres.empty?
      sql += " order by `#{@order}` desc" if @order
      sql += " limit #{@initial_limit}" if words.empty?
      sql
    end

    def convert(results)
      items = []
      results.each do |word|
        item = {}
        output = word[@output_key].to_s
        arg = output.force_encoding('UTF-8').scrub
        title = word[@title_key].force_encoding('UTF-8').scrub
        subtitle = ''
        if word[@subtitle_key]
          subtitle = word[@subtitle_key].force_encoding('UTF-8').scrub
        end

        item['uid'] = arg if @uid
        item['arg'] = arg
        item['valid'] = 'yes'
        item['autocomplete'] = title
        item['title'] = title
        item['subtitle'] = subtitle
        items << item
      end
      result = {}
      result['items'] = items
      result
    end
  end
end
