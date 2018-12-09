# frozen_string_literal: true

# Stock
#
#   Represents stocks of books in the store
#
class Stock < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  scope :in_stock, -> { where('quantity > 0') }

  validates :shop, :book, presence: true

  validates :book_id, uniqueness: { scope: :shop_id }

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
