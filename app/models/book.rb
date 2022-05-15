# frozen_string_literal: true

# Book
#
#   Represents core entity of the book shop
#
class Book < ApplicationRecord
  include Searchable

  belongs_to :publisher

  has_many :books_authors, dependent: :destroy
  has_many :authors, through: :books_authors

  has_many :books_genres, dependent: :destroy
  has_many :genres, through: :books_genres

  scope :by_isbn, ->(isbn10:, isbn13:) { where(isbn10: isbn10).or(where(isbn13: isbn13)) }
end
