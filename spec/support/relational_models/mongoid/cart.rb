class Cart
  include ::Mongoid::Document

  has_many :items
end