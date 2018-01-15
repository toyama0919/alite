# frozen_string_literal: true

require 'thor'
require 'json'

module Alite
  class CLI < Thor
    include Thor::Actions
    map '-s' => :suggest
    map '-d' => :diff

    class_option :config, aliases: '-c', type: :string, default: DEFAULT_CONFIG_PATH, desc: 'config file'
    class_option :profile, aliases: '-p', type: :string, default: DEFAULT_CONFIG_PROFILE, desc: 'profile name'
    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @class_options = config[:shell].base.options
      config = Util.get_profile(@class_options[:config], @class_options[:profile])
      @core = Core.new(config)
    end

    desc '-s', 'suggest'
    option :words, aliases: '-w', type: :string, required: true, desc: 'words'
    def suggest
      results = @core.suggestion_results(options[:words])
      puts results.to_json
    end

    desc '-d', 'diff'
    def diff
      require 'active_support/core_ext/string'
      exit 1 if STDIN.tty?
      data = JSON.parse(STDIN.read)
      selected = @core.diff(data)
      puts selected.to_json
    end
  end
end
