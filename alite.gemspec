# -*- encoding: utf-8 -*-

require File.expand_path('../lib/alite/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "alite"
  gem.version       = Alite::VERSION
  gem.summary       = %q{Summary}
  gem.description   = %q{Description}
  gem.license       = "MIT"
  gem.authors       = ["Hiroshi Toyama"]
  gem.email         = "toyama0919@gmail.com"
  gem.homepage      = "https://github.com/toyama0919/alite"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'thor'
  gem.add_dependency 'sqlite3'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'bundler', '~> 2.1.4'
  gem.add_development_dependency 'pry', '~> 0.11.3'
  gem.add_development_dependency "rake", ">= 12.3.3"
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubocop', '~> 0.52.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
