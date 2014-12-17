module Grape
  module Roar
    class Decorator < ::Roar::Decorator
      def self.represent(object, options = {})
        new(object)
      end
    end
  end
end
