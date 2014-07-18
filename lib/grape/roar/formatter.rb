module Grape
  module Formatter
    module Roar
      class << self
        def call(object, env)
          return object.to_json(env: env) if object.respond_to?(:to_json)
          MultiJson.dump(object)
        end
      end
    end
  end
end
