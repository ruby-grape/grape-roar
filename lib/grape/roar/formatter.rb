module Grape
  module Formatter
    module Roar
      class << self
        def call(object, env)
          object.respond_to?(:to_json) ? object.to_json(env: env) : MultiJson.dump(object)
        end
      end
    end
  end
end
