module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Adapter
          class ActiveRecord < Base
            include RelationalModels::Validator::ActiveRecord

            valid_for { |klass| klass < ::ActiveRecord::Base }

            def collection_methods
              @collection_methods ||= %i(has_many has_and_belongs_to_many)
            end

            def single_entity_methods
              @single_entity_methods ||= %i(has_one belongs_to)
            end
          end
        end
      end
    end
  end
end