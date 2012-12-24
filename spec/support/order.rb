require 'support/order_representer'

class Order
  include Roar::Representer::JSON
  include OrderRepresenter

  attr_accessor :id, :client_id, :articles

  def initialize(attrs = {})
    { :articles => [] }.merge(attrs).each_pair do |k, v|
      self.send("#{k}=", v)
    end
  end
end
