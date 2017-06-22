module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Validations
          module Mongoid
            def belongs_to_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] == (
                ::Mongoid::Relations::Referenced::In
              )

              raise Exceptions::InvalidRelationError,
                    'Expected Mongoid::Relations::Referenced::In'\
                    "got #{relation[:relation]}!"
            end

            # rubocop:disable Style/PredicateName
            def has_many_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] == (
                ::Mongoid::Relations::Referenced::Many
              )

              raise Exceptions::InvalidRelationError,
                    'Expected Mongoid::Relations::Referenced::Many'\
                    "got #{relation[:relation]}!"
            end
            # rubocop:enable Style/PredicateName
          end
        end
      end
    end
  end
end
