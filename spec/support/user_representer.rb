class UserRepresenter < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia

  property :name
  property :id

  link :self do
    "/user/#{represented.id}"
  end
end
