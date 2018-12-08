# frozen_string_literal: true

# Publisher
#
#   Represents a publisher of books
#
class Publisher < ApplicationRecord
  include Sortable
  include Booky::SQL::Pattern

  has_many :books, dependent: :destroy

  has_many :books_in_stock, -> { in_stock },
           source: :books,
           class_name: 'Book'

  has_many :shops_with_books, -> { distinct },
           through: :books_in_stock,
           source: :shops

  validates :name, presence: true

  # Search publishers by pattern
  #
  # NOTE: this method uses ILIKE in PostgreSQL and LIKE in MySQL.
  #
  # @param [String] query search pattern
  #
  # @return [ActiveRecord::Relation]
  #
  def self.search(query)
    table = arel_table
    pattern = "%#{Publisher.to_pattern(query)}%"

    where(table[:name].matches(pattern)).reorder(name: :asc)
  end
end
