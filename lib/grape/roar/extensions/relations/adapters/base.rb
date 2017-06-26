# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Adapters
          class Base
            class << self
              def valid_for?(klass)
                valid_proc.call(klass)
              rescue
                false
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

            def name_for_represented(_represented)
              raise NotImplementedError
            end

            def single_entity_methods
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
