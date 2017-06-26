# frozen_string_literal: true

class Item
  include ::Mongoid::Document

  belongs_to :cart
end
