# frozen_string_literal: true

require 'support/all/order_representer'

class Order
  include Roar::JSON
  include Roar::Hypermedia
  include OrderRepresenter

  attr_accessor :id, :client_id, :articles

  def initialize(attrs = {})
    { articles: [] }.merge(attrs).each_pair do |k, v|
      send("#{k}=", v)
    end
  end
end
