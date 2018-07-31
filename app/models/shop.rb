# Shop
#
#   Represents a store that sells copies of books
#
class Shop < ApplicationRecord
  has_many :stocks
  has_many :available_books, through: :stocks, source: :book

  has_many :not_empty_stocks, -> { in_stock },
           source: :stock,
           class_name: 'Stock'

  has_many :books_in_stock, through: :not_empty_stocks, source: :book

  has_many :sales
  has_many :sold_books, through: :sales, source: :book

  validates :name, presence: true
end
