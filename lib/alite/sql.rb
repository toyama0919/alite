# frozen_string_literal: true

require 'logger'
require 'sqlite3'
require 'string/scrub' if RUBY_VERSION.to_f < 2.1
require 'erb'
require 'ostruct'

module Alite
  class Sql < Core
    def initialize(config, verbose=false)
      @logger = get_logger(verbose)
      @config = config
      @db = ::SQLite3::Database.new @config['database']
      @sql = @config['sql']
      @where_match_columns = config['where_match_columns']

      # optional
      @uid = @config['uid']
    end

    private

    def make_sql(words)
      where_match_query = make_where_match_query(words)
      where_match_query = (where_match_query ? where_match_query : "1 = 1")
      sql = @sql.sub("where", "where #{where_match_query} and ")
      sql
    end
  end
end
