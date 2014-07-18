module Grape
  module Roar
    module Representer
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def represent(object, _options = {})
          object.extend self
          object
        end
      end
    end
  end
end
