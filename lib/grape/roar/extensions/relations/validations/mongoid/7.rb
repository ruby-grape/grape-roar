# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Validations
          module Mongoid
            include Validations::Misc

            def belongs_to_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Referenced::BelongsTo,
                ::Mongoid::Association::Referenced::BelongsTo::Proxy
              )
            end

            def embeds_many_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Embedded::EmbedsMany,
                ::Mongoid::Association::Embedded::EmbedsMany::Proxy
              )
            end

            def embeds_one_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Embedded::EmbedsOne,
                ::Mongoid::Association::Embedded::EmbedsOne::Proxy
              )
            end

            def has_many_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Referenced::HasMany,
                ::Mongoid::Association::Referenced::HasMany::Proxy
              )
            end

            def has_and_belongs_to_many_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Referenced::HasAndBelongsToMany,
                ::Mongoid::Association::Referenced::HasAndBelongsToMany::Proxy
              )
            end

            def has_one_valid?(relation)
              _valid_relation?(
                relation,
                ::Mongoid::Association::Referenced::HasOne,
                ::Mongoid::Association::Referenced::HasOne::Proxy
              )
            end

            private

            def _valid_relation?(relation, relation_klass, relation_proxy_klass)
              relation = klass.reflect_on_association(relation)

              related = relation.is_a?(Hash) ? relation[:relation] : relation.relation

              return true if related == relation_klass || related == relation_proxy_klass

              invalid_relation(relation.class, related)
            end
          end
        end
      end
    end
  end
end
