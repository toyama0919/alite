# frozen_string_literal: true

require 'alite/version'
require 'alite/constants'
require 'alite/util'
require 'alite/core'
require 'alite/cli'

module Alite
  def self.suggest(words, config: DEFAULT_CONFIG_PATH, profile: DEFAULT_CONFIG_PROFILE)
    get_core(config, profile).make_script_filter(words)
  end

  def self.diff(data, config: DEFAULT_CONFIG_PATH, profile: DEFAULT_CONFIG_PROFILE)
    get_core(config, profile).diff(data)
  end

  def self.get_core(config, profile)
    Core.new(Util.get_profile(config, profile))
  end
  private_class_method :get_core
end
