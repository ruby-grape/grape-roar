require 'grape/roar/extensions/relational_models/validator'

require 'grape/roar/extensions/relational_models/adapter/base'
require 'grape/roar/extensions/relational_models/adapter/active_record'

module Grape
  module Roar
    module Extensions
      module RelationalModels
        module Adapter
          def self.for(klass)
            (constants - [:Base]).inject(nil) do |_m, c|
              obj = const_get(c)
              obj.valid_for?(klass) ? obj.new(klass) : nil
            end
          end
        end
      end
    end
  end
end
