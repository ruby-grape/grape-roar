# frozen_string_literal: true

module ArticleRepresenter
  include Roar::JSON
  include Roar::Hypermedia
  include Grape::Roar::Representer

  property :title
  property :id

  link :self do
    "/article/#{id}"
  end
end
