module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Exceptions
          class InvalidRelationError < StandardError; end
          class UnsupportedRelationError < StandardError; end
        end
      end
    end
  end
end
