# frozen_string_literal: true

module Grape
  module Formatter
    module Roar
      class << self
        def call(object, env)
          object.is_a?(::Representable) ? object.to_json(user_options: { env: env }) : MultiJson.dump(object)
        end
      end
    end
  end
end
