module Grape
  module Roar
    module Extensions
      module RelationalModels
        class Mapper
          extend Forwardable

          def initialize(entity)
            @entity = entity
            @config = {}
          end

          def adapter
            @adapter ||= Adapter.for(model_klass)
          end

          def decorate(klass)
            @model_klass = klass

            config.each_pair do |relation, opts|
              raise unless adapter.validator.nil? || adapter.validator.send(
                "#{opts[:relation_kind]}_valid?", relation
              )

              decorate_relation_entity(relation, opts) unless opts.key(:extend)
              map_relation(relation, opts)
            end
          end

          def_delegators :@config, :[], :[]=

          private

          attr_reader :config, :entity, :model_klass

          def decorate_relation_entity(relation, opts)
            relation = relation.to_s
            base_path = entity.name.deconstantize.safe_constantize
            return if base_path.nil?

            to_extend = base_path.constants
                                 .find { |c| c.to_s.downcase.include?(relation.singularize) }

            opts.merge!(extend: "#{base_path}::#{to_extend}".safe_constantize)
          end

          def map_collection(relation, opts)
            return entity.link_relation(relation) if opts.fetch(:embedded, false)
            entity.collection(relation, opts)
          end

          def map_relation(relation, opts)
            return map_collection(
              relation, opts
            ) if adapter.collection_methods.include?(opts[:relation_kind])

            return map_single_entity(
              relation, opts
            ) if adapter.single_entity_methods.include?(opts[:relation_kind])

            raise Exceptions::InvalidRelationError, 'No such relation supported'
          end

          def map_single_entity(relation, opts)
            return entity.link_relation(relation) if opts.fetch(:embedded, false)
            entity.property(relation, opts)
          end
        end
      end
    end
  end
end
