# frozen_string_literal: true

require 'grape/roar/extensions/relations/validations'
require 'grape/roar/extensions/relations/adapters'
require 'grape/roar/extensions/relations/dsl_methods'
require 'grape/roar/extensions/relations/exceptions'
require 'grape/roar/extensions/relations/mapper'

module Grape
  module Roar
    module Extensions
      module Relations
        class << self
          def included(other)
            class << other
              include Extensions::Relations::DSLMethods
            end
          end
        end
      end
    end
  end
end
