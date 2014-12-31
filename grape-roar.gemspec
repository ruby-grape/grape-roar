# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grape/roar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Daniel Doubrovkine']
  gem.email         = ['dblock@dblock.org']
  gem.description   = 'Use Roar with Grape'
  gem.summary       = 'Enable Resource-Oriented Architectures in Grape API DSL'
  gem.homepage      = 'http://github.com/dblock/grape-roar'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.name          = 'grape-roar'
  gem.require_paths = ['lib']
  gem.version       = Grape::Roar::VERSION

  gem.add_dependency 'grape'
  gem.add_dependency 'roar', '>= 1.0'
end
