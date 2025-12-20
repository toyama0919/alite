# frozen_string_literal: true

require 'rspec'
require 'alite/version'

include Alite

def capture_stdout
  out = StringIO.new
  $stdout = out
  yield
  out.string
ensure
  $stdout = STDOUT
end

def capture_stderr
  out = StringIO.new
  $stderr = out
  yield
  out.string
ensure
  $stderr = STDERR
end

def clear_env
  ENV['PASSPHRASE'] = nil
end
