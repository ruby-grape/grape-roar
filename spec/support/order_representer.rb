require 'support/article'

module OrderRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :client_id

  collection :articles, :class => Article

  link :self do
    "/order/#{id}"
  end

  link :items do
    "/order/#{id}/items"
  end
end