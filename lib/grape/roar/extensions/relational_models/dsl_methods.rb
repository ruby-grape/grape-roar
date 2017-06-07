module Grape
  module Roar
    module Extensions
      module RelationalModels
        module DSLMethods
          def represent(object, _options)
            @validator_klass ||= object.class
            map_relations(object) unless relations_mapped?
            super
          end

          def belongs_to(relation, opts = {})
            mapper[relation] = opts.merge(
              relation_kind: __method__
            )
          end

          def has_many(relation, opts = {})
            mapper[relation] = opts.merge(
              relation_kind: __method__
            )
          end

          private

          def map_relations
            Mapper.new(self, object)
            relations_mapped? = true
          end

          attr_reader :relations_mapped?
        end
      end
    end
  end
end