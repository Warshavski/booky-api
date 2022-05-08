# frozen_string_literal: true

# Book
#
#   Represents core entity of the book shop
#
class Book < ApplicationRecord
  include Searchable

  belongs_to :publisher

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :genres

  validates :title, :published_at, :pages_count, presence: true

  validates :pages_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.0 }, allow_nil: true

  validates :isbn10, :isbn13, uniqueness: { allow_nil: true, case_sensitive: false }

  validates :isbn10, length: { is: 10, allow_nil: true }
  validates :isbn13, length: { is: 13, allow_nil: true }
end
