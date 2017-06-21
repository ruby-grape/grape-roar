module Grape
  module Roar
    module Extensions
      module RelationalModels
        module DSLMethods
          def link_relation(relation, is_collection = false)
            send(is_collection ? :links : :link, relation) do |opts|
              request = Grape::Request.new(opts[:env])
              data = represented.send(relation)
              is_collection = data.is_a?(Enumerable)

              mapped = Array.wrap(data).map do |object|
                href = "#{request.base_url}#{request.script_name}/"\
                         "#{relation}/#{object.id}"

                is_collection ? { href: href } : href
              end
              
              is_collection ? mapped : mapped.first
            end
          end

          def link_self
            link :self do |opts|
              request = Grape::Request.new(opts[:env])
              resource_path = self.class.name_for_represented(represented)
              "#{request.base_url}#{request.script_name}/"\
              "#{resource_path}/#{represented.try(:id)}"
            end
          end

          def name_for_represented(represented)
            relational_mapper.adapter.name_for_represented(represented)
          end

          def relation(relation_kind, rname, opts = {})
            relational_mapper[rname] = opts.merge(relation_kind: relation_kind)
          end

          def represent(object, _options)
            map_relations(object) unless relations_mapped
            super
          end

          private

          attr_reader :relations_mapped

          def map_relations(object)
            relational_mapper.decorate(object.class)
            @relations_mapped = true
          end

          def relational_mapper
            @relational_mapper ||= Mapper.new(self)
          end
        end
      end
    end
  end
end
