require 'support/order_representer'

class Order
  include Roar::JSON
  include OrderRepresenter

  attr_accessor :id, :client_id, :articles

  def initialize(attrs = {})
    { articles: [] }.merge(attrs).each_pair do |k, v|
      send("#{k}=", v)
    end
  end
end
