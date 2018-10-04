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

  validates :title, :publisher, :published_at, presence: true

  validates :isbn_10, length: { is: 10, allow_nil: true }
  validates :isbn_13, length: { is: 13, allow_nil: true }

  validates :isbn_10, :isbn_13, uniqueness: { allow_nil: true, case_sensitive: false }
end
