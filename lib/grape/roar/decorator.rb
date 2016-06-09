require 'roar/decorator'

module Grape
  module Roar
    class Decorator < ::Roar::Decorator
      def self.represent(object, _options = {})
        super(object)
      end
    end
  end
end
