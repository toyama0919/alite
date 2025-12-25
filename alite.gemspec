# frozen_string_literal: true

require 'English'
require File.expand_path('lib/alite/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'alite'
  gem.version       = Alite::VERSION
  gem.summary       = 'Summary'
  gem.description   = 'Description'
  gem.license       = 'MIT'
  gem.authors       = ['Hiroshi Toyama']
  gem.email         = 'toyama0919@gmail.com'
  gem.homepage      = 'https://github.com/toyama0919/alite'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 3.0.0'

  gem.add_dependency 'activesupport'
  gem.add_dependency 'ostruct'
  gem.add_dependency 'sqlite3', '~> 2.4'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.metadata['rubygems_mfa_required'] = 'true'
end
