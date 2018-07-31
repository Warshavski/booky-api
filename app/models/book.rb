# Book
#
#   Represents core entity of the book shop
#
class Book < ApplicationRecord
  belongs_to :publisher

  has_many :stocks
  has_many :shops, through: :stocks

  has_many :sales

  scope :in_stock, -> { joins(:stocks).where('stocks.quantity > 0').distinct }

  validates :title, :publisher, presence: true
end
