# frozen_string_literal: true

require File.expand_path('lib/grape/roar/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Daniel Doubrovkine']
  gem.email         = ['dblock@dblock.org']
  gem.description   = 'Use Roar with Grape'
  gem.summary       = 'Enable Resource-Oriented Architectures in Grape API DSL'
  gem.homepage      = 'http://github.com/ruby-grape/grape-roar'
  gem.license       = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = 'grape-roar'
  gem.require_paths = ['lib']
  gem.version       = Grape::Roar::VERSION

  gem.add_dependency 'grape'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'roar', '~> 1.1.0'
  gem.required_ruby_version = '>= 2.1.0'
  gem.metadata['rubygems_mfa_required'] = 'true'
end
