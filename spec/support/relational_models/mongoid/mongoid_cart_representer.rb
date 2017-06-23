class MongoidCartRepresenter < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::RelationalModels

  relation :has_many, :items

  link_self
end