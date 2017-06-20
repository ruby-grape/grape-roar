module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Adapter
          class Base
            class << self
              def valid_for?(klass)
                valid_proc.(klass) rescue false
              end

              def valid_for(&block)
                @valid_proc = block
              end

              private

              attr_reader :valid_proc
            end

            def initialize(klass)
              @klass = klass
            end

            def collection_methods
              raise NotImplementedError
            end

            def single_entity_methods
              raise NotImplementedError
            end

            def validator
              @validator ||= begin
                klass = self.class.name.demodulize
                Validator.const_get(klass) if Validator.const_defined?(klass)
              end
            end

            private

            attr_reader :klass
          end
        end
      end
    end
  end
end