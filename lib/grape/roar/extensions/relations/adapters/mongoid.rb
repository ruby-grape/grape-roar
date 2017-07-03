# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Adapters
          class Mongoid < Base
            include Validations::Mongoid

            valid_for { |klass| klass < ::Mongoid::Document }

            def collection_methods
              @collection_methods ||= %i[
                embeds_many has_many has_and_belongs_to_many
              ]
            end

            def name_for_represented(represented)
              klass_name = if represented.instance_of?(
                ::Mongoid::Relations::Targets::Enumerable
              )
                             represented.klass.name
                           else
                             represented.class.name
                           end
              klass_name.demodulize.pluralize.downcase
            end

            def single_entity_methods
              @single_entity_methods ||= %i[has_one belongs_to embeds_one]
            end
          end
        end
      end
    end
  end
end
