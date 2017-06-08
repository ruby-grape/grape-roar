module Grape
  module Roar
    module Extensions
      module RelationalModels
        class Mapper
          extend Forwardable

          def initialize(entity, represented)
            @model_klass = represented.class
          end

          def decorate
            config.each_pair do |relation, opts|
              raise unless validator.send(
                "#{opts[:relation_kind]}_valid?", relation
              )

              next map_collection(
                relation, opts
              ) if adapter.collection_methods.include?(relation)

              next map_single_entity(
                relation, opts
              ) if adapter.single_entity_methods.include?(relation)

              raise 'No such relation supported'
            end
          end

          def_delegators :@config, :[], :[]=

          private

          attr_reader :entity, :model_klass

          def map_single_entity(relation, opts)
          end

          def map_collection(relation, opts)
          end

          def adapter
            @adapter ||= Adapter.for(model_klass)
          end
        end
      end
    end
  end
end