module Grape
  module Formatter
    module Roar
      class << self
        def call(object, env)
          Grape::Formatter::Json.call object, env
        end
      end
    end
  end
end
