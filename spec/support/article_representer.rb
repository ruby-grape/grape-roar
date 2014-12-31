module ArticleRepresenter
  include Roar::JSON
  include Roar::Hypermedia

  property :title
  property :id

  link :self do
    "/article/#{id}"
  end
end
