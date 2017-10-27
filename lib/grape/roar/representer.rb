# frozen_string_literal: true

module Grape
  module Roar
    module Representer
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def represent(object, _options = {})
          raise TypeError if object.singleton_class == object.class
          object.extend(self)
          object
        end
      end
    end
  end
end
