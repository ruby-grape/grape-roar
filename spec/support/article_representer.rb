module ArticleRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :title
  property :id

  link :self do
    "/article/#{id}"
  end
end
