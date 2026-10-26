# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'ostruct'
require 'bigdecimal'
require 'base64'
require 'logger'

require 'bundler'
Bundler.setup :default, :test

require 'simplecov'
require 'simplecov-lcov'
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov::Formatter::LcovFormatter.config.lcov_file_name = 'grape-roar.lcov'
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start do
  add_filter '/spec/'
end

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
  config.filter_run_excluding activerecord: true unless defined?(ActiveRecord)
  config.filter_run_excluding mongoid: true unless defined?(Mongoid)
end

Dir["#{File.dirname(__FILE__)}/support/all/**/*.rb"].sort.each { |f| require f }

# For Relational Extension Tests
if defined?(Mongoid)
  ENV['MONGOID_ENV'] ||= 'test'
  Mongoid.load!('./spec/config/mongoid.yml')
  Dir["#{File.dirname(__FILE__)}/support/mongoid/**/*.rb"].sort.each { |f| require f }
end
