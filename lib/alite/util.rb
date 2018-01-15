# frozen_string_literal: true

require 'yaml'
require 'erb'

module Alite
  class Util
    def self.get_profile(config_path, profile)
      config = YAML.load(ERB.new(File.read(config_path)).result(binding))
      config[profile]
    end
  end
end
