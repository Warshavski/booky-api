# frozen_string_literal: true

# Publisher
#
#   Represents a publisher of books
#
class Publisher < ApplicationRecord
  include Searchable

  has_many :books, dependent: :restrict_with_exception

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
    fuzzy_search(query, %i[name])
  end
end
