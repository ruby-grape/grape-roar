# frozen_string_literal: true

module MongoidCartRepresenter
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  relation :has_many, :items

  link_self
end

# Class style below, but want to test module

# class MongoidCartRepresenter < Grape::Roar::Decorator
#   include Roar::JSON
#   include Roar::JSON::HAL
#   include Roar::Hypermedia

#   include Grape::Roar::Extensions::Relations

#   relation :has_many, :items

#   link_self
# end
