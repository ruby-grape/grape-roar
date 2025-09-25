# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Validations
          module ActiveRecord
            include Validations::Misc

            def belongs_to_valid?(relation)
              _valid_relation? relation, ::ActiveRecord::Reflection::BelongsToReflection
            end

            def has_many_valid?(relation)
              _valid_relation? relation, ::ActiveRecord::Reflection::HasManyReflection
            end

            def has_and_belongs_to_many_valid?(relation)
              _valid_relation? relation, ::ActiveRecord::Reflection::HasAndBelongsToManyReflection
            end

            def has_one_valid?(relation)
              _valid_relation? relation, ::ActiveRecord::Reflection::HasOneReflection
            end

            private

            def _valid_relation?(relation, relation_klass)
              relation = klass.reflections[relation]
              return true if relation.is_a?(relation_klass)

              invalid_relation(relation_klass, relation.class)
            end
          end
        end
      end
    end
  end
end
