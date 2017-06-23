module Grape
  module Roar
    module Extensions
      module RelationalModels
        module DSLMethods
          def link_relation(relation, is_collection = false)
            send(is_collection ? :links : :link, relation) do |opts|
              request = Grape::Request.new(opts[:env])
              data = represented.send(relation)

              mapped = Array.wrap(data).map do |object|
                href = [ self.class.map_base_url.(opts),
                         self.class.map_resource_path.(opts, object, relation)
                       ].join('/')

                is_collection ? { href: href } : href
              end

              is_collection ? mapped : mapped.first
            end
          end

          def link_self
            link :self do |opts|
              resource_path = self.class.name_for_represented(represented)
              [ self.class.map_base_url.(opts),
                "#{resource_path}/#{represented.try(:id)}" ].join('/')
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

          def map_resource_path(&block)
            @map_resource_path ||= if block.nil?
              proc { |opts, object, relation| "#{relation}/#{object.id}" }
            else
            end
          end

          def map_base_url(&block)
            @map_base_url ||= if block.nil?
              proc do |opts|
                request = Grape::Request.new(opts[:env])
                "#{request.base_url}#{request.script_name}"
              end
            else
              block
            end
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
