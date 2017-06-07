module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Validator
          module ActiveRecord
            def belongs_to_valid?(relation)
              klass.reflections[relation].is_a?( 
                ::ActiveRecord::Reflection::BelongsToReflection
              )
            end

            def has_many_valid?(relation)
              klass.reflections[relation].is_a?(
                ::ActiveRecord::Reflection::HasManyReflection
              )
            end
          end
        end
      end
    end
  end
end