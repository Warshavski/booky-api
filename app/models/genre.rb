# Genre
#
#   Represents book genre
#
class Genre < ApplicationRecord
  include Sortable
  include SQL::Pattern

  has_and_belongs_to_many :books

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  before_save -> { self.name.downcase! }

  # Search genre by pattern
  #
  # NOTE: this method uses ILIKE in PostgreSQL and LIKE in MySQL.
  #
  # @param [String] query search pattern
  #
  # @return [ActiveRecord::Relation]
  #
  def self.search(query)
    table = arel_table
    pattern = "%#{Genre.to_pattern(query)}%"

    where(table[:name].matches(pattern)).reorder(name: :asc)
  end
end
