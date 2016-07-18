module Grape
  module Roar
    module Representer
      def self.included(base)
        super
        base.send(:include, ::Roar::Representer)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def represent(object, _options = {})
          super(object)
        end
      end
    end
  end
end
