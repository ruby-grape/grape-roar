module Grape
  module Roar
    module Extensions
      module RelationalModels
        class Mapper
          autoload :Base, 'mapper/base'

          autoload :ActiveRecord, 'mapper/active_record'
          autoload :Mongoid, 'mapper/mongoid'

          class << self
            def for(klass)
            end
          end
        end
      end
    end
  end
end