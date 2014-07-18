module Grape
  module Formatter
    module Roar
      class << self
        def call(object, env)
          object.to_json(env: env)
        end
      end
    end
  end
end
