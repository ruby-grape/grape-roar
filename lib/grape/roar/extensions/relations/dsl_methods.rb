# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module DSLMethods
          def link_relation(relation, is_collection = false, dsl = self)
            send(is_collection ? :links : :link, relation) do |opts|
              data = represented.send(relation)

              mapped = Array.wrap(data).map do |object|
                href = [dsl.map_base_url.call(opts),
                        dsl.map_resource_path.call(opts, object, relation)].join('/')

                is_collection ? { href: href } : href
              end

              is_collection ? mapped : mapped.first
            end
          end

          def link_self
            relational_mapper[:self] = { relation_kind: :self }
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

          def map_self_url(dsl = self)
            link :self do |opts|
              resource_path = dsl.name_for_represented(represented)
              [dsl.map_base_url.call(opts),
               "#{resource_path}/#{represented.try(:id)}"].join('/')
            end
          end

          def map_resource_path(&block)
            @map_resource_path ||= if block.nil?
                                     proc do |_opts, object, relation_name|
                                       "#{relation_name}/#{object.id}"
                                     end
                                   else
                                     block
                                   end
          end

          def name_for_represented(represented)
            relational_mapper.adapter.name_for_represented(represented)
          end

          def relation(relation_kind, rname, opts = {})
            relational_mapper[rname] = opts.merge(relation_kind: relation_kind)
          end

          def represent(object, _options)
            object.extend(self) unless is_a?(Class)
            map_relations(object) unless relations_mapped
            is_a?(Class) ? super : object
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
