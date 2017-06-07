require 'grape/roar/extensions/relational_models/adapter'
require 'grape/roar/extensions/relational_models/dsl_methods'
require 'grape/roar/extensions/relational_models/exceptions'
require 'grape/roar/extensions/relational_models/mapper'

module Grape
  module Roar
    module Extensions
      module RelationalModels
        class << self
          def included(other)
            registered_representers << other
            
            class << other
              include ActiveModelRelations::DSLMethods
            end
          end

          def registered_representers
            @registered_representers ||= []
          end
        end
      end
    end
  end
end