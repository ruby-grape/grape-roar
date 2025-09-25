# frozen_string_literal: true

if defined?(Mongoid)
  if Gem::Version.new(Mongoid::VERSION) < Gem::Version.new('7')
    require_relative 'mongoid/6'
  else
    require_relative 'mongoid/7'
  end
end
