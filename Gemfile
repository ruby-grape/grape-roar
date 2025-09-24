# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'activerecord', ENV['ACTIVERECORD_VERSION'], require: 'active_record' if ENV.key?('ACTIVERECORD_VERSION')
gem 'grape', ENV['GRAPE_VERSION'] if ENV.key?('GRAPE_VERSION')
gem 'mongoid', ENV['MONGOID_VERSION'], require: 'mongoid' if ENV.key?('MONGOID_VERSION')

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
  gem 'rack', '~> 2.2.17'
  gem 'rake'
  gem 'rubocop', '1.80.2'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'sorted_set'
end
