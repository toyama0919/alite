# frozen_string_literal: true

require 'thor'
require 'json'

module Alite
  class CLI < Thor
    include Thor::Actions
    map '-s' => :script_filter

    class_option :config, aliases: '-c', type: :string, default: DEFAULT_CONFIG_PATH, desc: 'config file'
    class_option :profile, aliases: '-p', type: :string, default: DEFAULT_CONFIG_PROFILE, desc: 'profile name'
    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @class_options = config[:shell].base.options
      config = Util.get_profile(@class_options[:config], @class_options[:profile])
      if config
        @core = Core.new(config)
      end
    end

    desc '-s', 'suggest'
    option :words, aliases: '-w', type: :string, required: true, desc: 'words'
    def script_filter
      results = @core.make_script_filter(options[:words])
      puts results.to_json
    end
  end
end
