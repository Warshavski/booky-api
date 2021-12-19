# frozen_string_literal: true

# Genre
#
#   Represents book genre
#
class Genre < ApplicationRecord
  include Searchable

  has_and_belongs_to_many :books

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save -> { name.downcase! }

  # Search genre by pattern
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
