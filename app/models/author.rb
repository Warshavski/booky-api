# Author
#
#   Represents the creator or originator of the book
#
class Author < ApplicationRecord
  include Sortable
  include Booky::SQL::Pattern

  has_and_belongs_to_many :books

  scope :order_first_name_asc,  -> { reorder(first_name: :asc) }
  scope :order_first_name_desc, -> { reorder(first_name: :desc) }

  scope :order_last_name_asc,   -> { reorder(last_name: :asc) }
  scope :order_last_name_desc,  -> { reorder(last_name: :desc) }

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
    table = arel_table
    pattern = "%#{Author.to_pattern(query)}%"

    order = <<~SQL.squish
      CASE
        WHEN authors.last_name = %{query} THEN 0
        WHEN authors.first_name = %{query} THEN 1
        ELSE 3
      END
    SQL

    where(table[:last_name].matches(pattern).or(table[:first_name].matches(pattern)))
      .reorder(format(order, query: ActiveRecord::Base.connection.quote(query)), :last_name)
  end

  # Sort books by sort method(field and direction)
  #
  # @param [Symbol, String] method sort type
  #
  # @return [ActiveRecord::Relation]
  #
  def self.order_by(method)
    case method.to_s
    when 'first_name_asc' then
      order_first_name_asc
    when 'first_name_desc' then
      order_first_name_desc
    when 'last_name_asc' then
      order_last_name_asc
    when 'last_name_desc' then
      order_last_name_desc
    else
      super(method)
    end
  end
end
