# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Validations
          module Misc
            def invalid_relation(valid, invalid)
              raise Exceptions::InvalidRelationError,
                    "Expected #{valid}, got #{invalid}!"
            end
          end
        end
      end
    end
  end
end
