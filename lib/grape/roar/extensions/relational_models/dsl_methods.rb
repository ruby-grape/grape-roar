module Grape
  module Roar
    module Extensions
      module RelationalModels
        module DSLMethods
          def represent(object, _options)
            map_relations(object) unless relations_mapped
            super
          end

          def relation(relation_kind, rname, opts = {})
            relational_mapper[rname] = opts.merge(relation_kind: relation_kind)
          end

          def link_relation(relation)
            link(relation, &method(:map_relation_link).curry[relation])
          end

          def link_self
            link :self do |opts|
              request = Grape::Request.new(opts[:env])
              "#{request.base_url}#{request.script_name}/"\
              "foo"\
                # "#{name_for_represented(represented)}/"\
                "#{represented.try(:id)}"
            end
          end

          private

          attr_reader :relations_mapped

          def map_relation_link(getter, opts)
            request = Grape::Request.new(opts[:env])
            represented.send(getter).map do |other|
              { href: "#{request.base_url}#{request.script_name}/"\
                      "#{getter}/#{other.id}" }
            end
          end

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