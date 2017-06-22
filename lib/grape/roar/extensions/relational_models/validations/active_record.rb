module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Validations
          module ActiveRecord
            include Validations::Misc

            def belongs_to_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::BelongsToReflection
              )

              invalid_relation(
                ::ActiveRecord::Reflection::BelongsToReflection,
                relation.class
              )
            end

            # rubocop:disable Style/PredicateName
            def has_many_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::HasManyReflection
              )

              invalid_relation(
                ::ActiveRecord::Reflection::HasManyReflection,
                relation.class
              )
            end
            # rubocop:enable Style/PredicateName

            # rubocop:disable Style/PredicateName
            def has_and_belongs_to_many_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::HasAndBelongsToManyReflection
              )

              invalid_relation(
                ::ActiveRecord::Reflection::HasAndBelongsToManyReflection,
                relation.class
              )
            end
            # rubocop:enable Style/PredicateName

            # rubocop:disable Style/PredicateName
            def has_one_valid?(relation)
              relation = klass.reflections[relation]

              return true if relation.is_a?(
                ::ActiveRecord::Reflection::HasOneReflection
              )

              invalid_relation(
                ::ActiveRecord::Reflection::HasOneReflection,
                relation.class
              )
            end
            # rubocop:enable Style/PredicateName
          end
        end
      end
    end
  end
end
