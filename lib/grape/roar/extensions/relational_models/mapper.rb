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

          def decorate(klass)
            @model_klass = klass

            config.each_pair do |relation, opts|
              # raise unless validator.send(
              #   "#{opts[:relation_kind]}_valid?", relation
              # )

              next map_collection(
                relation, opts
              ) if adapter.collection_methods.include?(opts[:relation_kind])

              next map_single_entity(
                relation, opts
              ) if adapter.single_entity_methods.include?(opts[:relation_kind])

              raise Exceptions::InvalidRelationError, 
                    'No such relation supported'
            end
          end

          def_delegators :@config, :[], :[]=

          private
          attr_reader :config, :entity, :model_klass

          def adapter
            @adapter ||= Adapter.for(model_klass)
          end

          def decorate_associated_entity(relation, opts)
            relation = relation.to_s
            base_path = entity.name.deconstantize.safe_constantize

            to_extend = base_path.constants
                                 .find do |c| 
                                    c.to_s
                                     .downcase
                                     .include?(relation.singularize)
                                  end

            "#{base_path}::#{to_extend}".safe_constantize
          end

          def map_single_entity(relation, opts)
            return entity.send(:link_relation, relation) if opts.fetch(:embedded, false)
            # more logic here
          end

          def map_collection(relation, opts)
            return entity.send(:link_relation, relation) if opts.fetch(:embedded, false)
            decorate_associated_entity(relation, opts)
            entity.send(:collection, relation, opts)
          end

          def process_opts(opts)
            relation_extend = find_associate_entity(relation)
            opts.merge!(extend: relation_extend) if relation_extend.present?
          end

          def validator
          end
        end
      end
    end
  end
end