# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Validations
          module Mongoid
            include Validations::Misc

            def belongs_to_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Referenced::In

              invalid_relation(
                ::Mongoid::Relations::Referenced::In, relation[:relation]
              )
            end

            def embeds_many_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Embedded::Many

              invalid_relation(
                ::Mongoid::Relations::Embedded::Many, relation[:relation]
              )
            end

            def embeds_one_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Embedded::One

              invalid_relation(
                ::Mongoid::Relations::Embedded::One, relation[:relation]
              )
            end

            # rubocop:disable Style/PredicateName
            def has_many_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Referenced::Many

              invalid_relation(
                ::Mongoid::Relations::Referenced::Many, relation[:relation]
              )
            end
            # rubocop:enable Style/PredicateName

            # rubocop:disable Style/PredicateName
            def has_and_belongs_to_many_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Referenced::ManyToMany

              invalid_relation(
                ::Mongoid::Relations::Referenced::ManyToMany,
                relation[:relation]
              )
            end
            # rubocop:enable Style/PredicateName

            # rubocop:disable Style/PredicateName
            def has_one_valid?(relation)
              relation = klass.reflect_on_association(relation)

              return true if relation[:relation] ==
                             ::Mongoid::Relations::Referenced::One

              invalid_relation(
                ::Mongoid::Relations::Referenced::One, relation[:relation]
              )
            end
            # rubocop:enable Style/PredicateName
          end
        end
      end
    end
  end
end
