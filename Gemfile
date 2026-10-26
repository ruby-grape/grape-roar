# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord', ENV['ACTIVERECORD_VERSION'], require: 'active_record' if ENV.key?('ACTIVERECORD_VERSION')
gem 'grape', ENV['GRAPE_VERSION'] if ENV.key?('GRAPE_VERSION')
gem 'mongoid', ENV['MONGOID_VERSION'], require: 'mongoid' if ENV.key?('MONGOID_VERSION')
gem 'rack', ENV['RACK_VERSION'] if ENV.key?('RACK_VERSION')

gemspec

group :test do
  gem 'rack-test'
  gem 'rspec'
end

group :development, :test do
  gem 'base64'
  gem 'bigdecimal'
  gem 'mutex_m'
  gem 'nokogiri'
  gem 'ostruct'
  gem 'rake'
  gem 'rubocop', '~> 1.92.0', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'sorted_set'
end

# The Danger plugins require Ruby 3.1+, independently of the runtime test matrix.
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')
  group :danger do
    gem 'danger', require: false
    gem 'danger-changelog', require: false
    gem 'danger-pr-comment', require: false
    gem 'danger-toc', require: false
  end
end
