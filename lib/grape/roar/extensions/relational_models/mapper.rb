module Grape
  module Roar
    module Extensions
      module RelationalModels
        class Mapper
          extend Forwardable

          # ATTACK PLAN:
          # test validator first, easiest
          #
          # Move these to the validator
          # validate both properties and the available DSL methods
          # at the same time!

          def initialize(entity, represented)
            @model_klass = represented.class
          end

          # def decorate
          #   config.each_pair do |relation, opts|
          #     raise unless validator.send(
          #       "#{opts[:relation_kind]}_valid?", relation
          #     )
          #   end
          # end

          def_delegators :@config, :[], :[]=

          private

          attr_reader :entity, :model_klass

          def map_single(relation, opts)
          end

          def map_collection(relation, opts)
          end

          def validator
            @validator ||= Validator.for(model_klass)
          end
        end
      end
    end
  end
end