# frozen_string_literal: true

# Author
#
#   Represents the creator or originator of the book
#
class Author < ApplicationRecord
  include Searchable

  has_and_belongs_to_many :books

  validates :first_name, :last_name, presence: true

  # Search books by pattern
  #
  # NOTE: this method uses ILIKE in PostgreSQL and LIKE in MySQL.
  #
  # @param [String] query search pattern
  #
  # @return [ActiveRecord::Relation]
  #
  def self.search(query)
    fuzzy_search(query, %i[first_name last_name])
  end
end
