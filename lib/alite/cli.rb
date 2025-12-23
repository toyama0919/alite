# frozen_string_literal: true

require 'thor'
require 'json'

module Alite
  class CLI < Thor
    include Thor::Actions

    map '-s' => :script_filter

    class_option :config, aliases: '-c', type: :string, default: DEFAULT_CONFIG_PATH, desc: 'config file'
    class_option :profile, aliases: '-p', type: :string, default: DEFAULT_CONFIG_PROFILE, desc: 'profile name'
    class_option :verbose, aliases: '-V', type: :boolean, default: false, desc: 'verbose output'
    def initialize(args = [], options = {}, config = {})
      super
      @class_options = config[:shell].base.options
      config = Util.get_profile(@class_options[:config], @class_options[:profile])
      return unless config

      @core = config['sql'] ? Sql.new(config, @class_options[:verbose]) : Core.new(config, @class_options[:verbose])
    end

    desc '-s', 'suggest'
    option :query, aliases: '-w', type: :string, required: true, desc: 'query'
    option :arg_vars, aliases: '-a', type: :hash, desc: 'arg variables (e.g., id:123 name:value)'
    def script_filter
      results = @core.make_script_filter(options[:query], options[:arg_vars])
      puts results.to_json
    end
  end
end
