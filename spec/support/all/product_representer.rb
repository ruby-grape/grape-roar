# frozen_string_literal: true

require 'roar/json/hal'

module ProductRepresenter
  include Roar::JSON
  include Roar::Hypermedia
  include Grape::Roar::Representer

  property :title
  property :id

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    request.url.to_s
  end
end
