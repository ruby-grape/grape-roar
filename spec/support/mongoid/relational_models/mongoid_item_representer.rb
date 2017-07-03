# frozen_string_literal: true

class MongoidItemRepresenter < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  relation :belongs_to, :cart, embedded: true

  link_self
end
