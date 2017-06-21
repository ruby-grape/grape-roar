module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Validations
          module ActiveRecord
            def belongs_to_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::BelongsToReflection
              )

              raise Exceptions::InvalidRelationError,
                    'Expected ActiveRecord::Relflection::BelongsToReflection'\
                    "got #{relation.class}!"
            end

            # rubocop:disable Style/PredicateName
            def has_many_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::HasManyReflection
              )

              raise Exceptions::InvalidRelationError,
                    'Expected ActiveRecord::Relflection::HasManyReflection'\
                    "got #{relation.class}!"
            end
            # rubocop:enable Style/PredicateName
          end
        end
      end
    end
  end
end
