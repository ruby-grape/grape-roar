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
              decorate_relation_entity(relation, opts) unless opts.key(:extend)
              map_relation(relation, opts)
            end
          end

          def_delegators :@config, :[], :[]=

          private

          attr_reader :config, :entity, :model_klass

          def decorate_relation_entity(relation, opts)
            relation = relation.to_s
            base_path = entity.name.deconstantize
            base_path = base_path.empty? ? Object : base_path.safe_constantize

            return if base_path.nil?

            to_extend = base_path.constants
                                 .find { |c| c.to_s.downcase.include?(relation.singularize) }

            opts.merge!(extend: "#{base_path}::#{to_extend}".safe_constantize)
          end

          def map_collection(relation, opts)
            return entity.link_relation(relation, true) unless opts.fetch(:embedded, false)
            entity.collection(relation, opts)
          end

          def map_relation(relation, opts)
            if adapter.collection_methods.include?(opts[:relation_kind])
              map_collection(relation, opts)
            elsif adapter.single_entity_methods.include?(opts[:relation_kind])
              map_single_entity(relation, opts)
            else
              raise Exceptions::UnsupportedRelationError,
                    'No such relation supported'
            end

            validate_relation(relation, opts[:relation_kind])
          end

          def map_single_entity(relation, opts)
            return entity.link_relation(relation) unless opts.fetch(:embedded, false)
            entity.property(relation, opts)
          end

          def validate_relation(relation, kind)
            validator_method = "#{kind}_valid?"
            return true unless adapter.respond_to?(validator_method)
            adapter.send(validator_method, relation.to_s)
          end
        end
      end
    end
  end
end
