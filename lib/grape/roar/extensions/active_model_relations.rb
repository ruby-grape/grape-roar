module Grape
  module Roar
    module Extensions
      module ActiveModelRelations
        class << self
          def included(other)
            registered_representers << other
            other.include(ActiveModelRelations::DSLMethods)
          end

          def registered_representers
            @registered_representers ||= []
          end
        end
      end
    end
  end
end