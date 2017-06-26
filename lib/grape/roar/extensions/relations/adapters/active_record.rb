# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Adapters
          class ActiveRecord < Base
            include Validations::ActiveRecord

            valid_for { |klass| klass < ::ActiveRecord::Base }

            def collection_methods
              @collection_methods ||= %i[has_many has_and_belongs_to_many]
            end

            def name_for_represented(represented)
              klass_name = case represented
                           when ::ActiveRecord::Relation
                             represented.klass.name
                           else
                             represented.class.name
                           end
              klass_name.demodulize.pluralize.downcase
            end

            def single_entity_methods
              @single_entity_methods ||= %i[has_one belongs_to]
            end
          end
        end
      end
    end
  end
end
