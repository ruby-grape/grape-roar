require 'roar/json/hal'
require 'support/product_representer'

module ProductsRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia
  include Grape::Roar::Representer

  collection :entries, extend: ProductRepresenter, as: :products, embedded: true
end
