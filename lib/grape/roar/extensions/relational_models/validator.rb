module Grape
  module Roar
    module Extensions
      module RelationalModels
        # Break into Adapters with validators?
        # fuck this became a lot of work
        
        class Validator
          autoload :ActiveRecord, 'validator/active_record'
          autoload :Mongoid, 'validator/mongoid'

          def self.for(klass)
            if klass < ActiveRecord::Base
              Validator::ActiveRecord.new(klass)
            elsif klass < Mongoid::Document
              Validator::Mongoid.new(klass)
            end
          end

          class Base
            def initialize(klass)
              @klass = klass
            end

            def belongs_to_valid?(relation)
              raise NotImplementedError
            end

            def has_many_valid?(relation)
              raise NotImplementedError
            end

            private

            attr_reader :klass
          end
        end
      end
    end
  end
end