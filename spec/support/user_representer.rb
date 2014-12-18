class UserRepresenter < Grape::Roar::Decorator
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :name
  property :id

  link :self do
    "/user/#{represented.id}"
  end
end
