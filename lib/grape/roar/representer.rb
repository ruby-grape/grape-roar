# frozen_string_literal: true

module Grape
  module Roar
    module Representer
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def represent(object, _options = {})
          object.extend(self) unless object.singleton_class == object.class
        rescue TypeError => e
          # What do we do here?
          puts "Grape/Roar: Could not represent a(n) #{object.class.name}: #{e}"
        ensure
          object
        end
      end
    end
  end
end
