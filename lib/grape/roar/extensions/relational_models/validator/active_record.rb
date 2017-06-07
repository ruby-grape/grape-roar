module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Validator
          class ActiveRecord < Base
            def belongs_to_valid?(relation)
              klass.reflections[relation] == 
                ActiveRecord::Reflection::BelongsToReflection
            end

            def has_many_valid?(relation)
              klass.reflections[relation] == 
                ActiveRecord::Reflection::HasManyReflection
            end
          end
        end
      end
    end
  end
end