# frozen_string_literal: true

require 'grape/roar/extensions/relations/adapters/base'
require 'grape/roar/extensions/relations/adapters/active_record'
require 'grape/roar/extensions/relations/adapters/mongoid'

module Grape
  module Roar
    module Extensions
      module Relations
        module Adapters
          def self.for(klass)
            (constants - [:Base]).inject(nil) do |m, c|
              obj = const_get(c)
              obj.valid_for?(klass) ? obj.new(klass) : m
            end
          end
        end
      end
    end
  end
end
