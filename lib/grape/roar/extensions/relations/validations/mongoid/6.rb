# frozen_string_literal: true

module Grape
  module Roar
    module Extensions
      module Relations
        module Validations
          module Mongoid
            include Validations::Misc

            def belongs_to_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Referenced::In
            end

            def embeds_many_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Embedded::Many
            end

            def embeds_one_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Embedded::One
            end

            def has_many_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Referenced::Many
            end

            def has_and_belongs_to_many_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Referenced::ManyToMany
            end

            def has_one_valid?(relation)
              _valid_relation? relation, ::Mongoid::Relations::Referenced::One
            end

            private

            def _valid_relation?(relation, relation_klass)
              relation = klass.reflect_on_association(relation)
              return true if relation[:relation] == relation_klass

              invalid_relation(relation_klass, relation[:relation])
            end
          end
        end
      end
    end
  end
end
