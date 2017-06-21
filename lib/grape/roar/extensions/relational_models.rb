require 'grape/roar/extensions/relational_models/adapter'
require 'grape/roar/extensions/relational_models/dsl_methods'
require 'grape/roar/extensions/relational_models/exceptions'
require 'grape/roar/extensions/relational_models/mapper'
require 'grape/roar/extensions/relational_models/validations'

module Grape
  module Roar
    module Extensions
      module RelationalModels
        class << self
          def included(other)
            class << other
              include Extensions::RelationalModels::DSLMethods
            end
          end
        end
      end
    end
  end
end
