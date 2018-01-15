require 'logger'

module Alite
  class Core

    def initialize
      @logger = Logger.new(STDOUT)
    end

    def sample
      []
    end

  end
end
