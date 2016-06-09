require 'support/article'

module OrderRepresenter
  include Roar::JSON
  include Roar::Hypermedia

  property :id
  property :client_id

  collection :articles, class: Article

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.url}"
  end

  link :items do
    "/order/#{id}/items"
  end
end
