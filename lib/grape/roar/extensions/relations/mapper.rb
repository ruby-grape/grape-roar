# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        class Mapper
          extend Forwardable

          def initialize(entity)
            @entity = entity
            @config = {}
          end

          def adapter
            @adapter ||= Adapters.for(model_klass)
          end

          def decorate(klass)
            @model_klass = klass

            config.each_pair do |relation, opts|
              representer_for(relation.to_s, opts) unless opts.key(:extend)
              map_relation(relation, opts)
            end
          end

          def_delegators :@config, :[], :[]=

          private

          attr_reader :config, :entity, :model_klass

          def find_representer(base, target_name, const)
            const = base.const_get(const)
            return false if const.nil? || !const.is_a?(Module)
            (const < ::Roar::JSON::HAL) && const.name
                                                .downcase
                                                .include?(target_name.singularize)
          end

          def map_collection(relation, opts)
            return entity.link_relation(relation, true) unless opts.fetch(:embedded, false)
            entity.collection(relation, opts)
          end

          def map_relation(relation, opts)
            map = if adapter.collection_methods.include?(opts[:relation_kind])
                    :map_collection
                  elsif adapter.single_entity_methods
                               .include?(opts[:relation_kind]) || opts[:relation_kind] == :self
                    :map_single_entity
                  else raise Exceptions::UnsupportedRelationError,
                             'No such relation supported'
                  end

            send(map, relation, opts)
            validate_relation(relation, opts[:relation_kind])
          end

          def map_single_entity(relation, opts)
            return entity.map_self_url if opts[:relation_kind] == :self
            return entity.link_relation(relation) unless opts.fetch(:embedded, false)
            entity.property(relation, opts)
          end

          def representer_for(relation, opts)
            base_path = entity.name.deconstantize
            base_path = base_path.empty? ? Object : base_path.safe_constantize
            return if base_path.nil?

            to_extend = base_path.constants
                                 .find(&method(:find_representer).curry[
                                   base_path, relation
                                 ])

            opts.merge!(extend: "#{base_path}::#{to_extend}".safe_constantize)
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
