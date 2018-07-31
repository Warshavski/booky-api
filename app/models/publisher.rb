# Publisher
#
#   Represents a publisher of books
#
class Publisher < ApplicationRecord
  has_many :books

  has_many :books_in_stock, -> { in_stock },
           source: :books,
           class_name: 'Book'

  has_many :shops_with_books, -> { distinct },
           through: :books_in_stock,
           source: :shops

  validates :name, presence: true
end
