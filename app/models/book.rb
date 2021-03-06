# frozen_string_literal: true

# Book
#
#   Represents core entity of the book shop
#
class Book < ApplicationRecord
  include Sortable
  include Searchable

  belongs_to :publisher

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :genres

  scope :order_title_asc,   -> { reorder(title: :asc) }
  scope :order_title_desc,  -> { reorder(title: :desc) }

  validates :title, :publisher, :published_at, :pages_count, presence: true

  validates :pages_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true

  validates :isbn_10, length: { is: 10, allow_nil: true }
  validates :isbn_13, length: { is: 13, allow_nil: true }

  validates :isbn_10, :isbn_13, uniqueness: { allow_nil: true, case_sensitive: false }

  # Search books by pattern
  #
  # NOTE: this method uses ILIKE in PostgreSQL and LIKE in MySQL.
  #
  # @param [String] query search pattern
  #
  # @return [ActiveRecord::Relation]
  #
  def self.search(query)
    fuzzy_search(query, %i[title])
  end

  # Sort books by sort method(field and direction)
  #
  # @param [Symbol, String] method sort type
  #
  # @return [ActiveRecord::Relation]
  #
  def self.order_by(method)
    case method.to_s
    when 'title_asc' then
      order_title_asc
    when 'title_desc' then
      order_title_desc
    else
      super(method)
    end
  end
end
