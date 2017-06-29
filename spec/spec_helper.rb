# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bundler'
Bundler.setup :default, :test
Bundler.require

require 'grape'

require 'roar'
require 'roar/json'
require 'roar/hypermedia'

require 'grape/roar'
require 'rack/test'

require 'rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.filter_run_excluding(
    active_record: true, mongoid: true
  )
end

Dir["#{File.dirname(__FILE__)}/support/all/**/*.rb"].each { |f| require f }

# For Relational Extension Tests
if defined?(Mongoid)
  ENV['MONGOID_ENV'] ||= 'test'
  Mongoid.load!('./spec/config/mongoid.yml')
  Dir["#{File.dirname(__FILE__)}/support/mongoid/**/*.rb"].each { |f| require f }
end
