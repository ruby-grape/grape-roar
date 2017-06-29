# frozen_string_literal: true

class Cart
  include ::Mongoid::Document

  has_many :items
end
