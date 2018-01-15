require 'alite/version'
require 'alite/constants'
require 'alite/util'
require 'alite/core'
require 'alite/cli'

module Alite
  def self.sample(table)
    params = ['sample']
    params.concat(['--table', table])
    Alite::CLI.start(params)
  end
end
