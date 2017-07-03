# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
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
          end
        end
      end
    end
  end
end
