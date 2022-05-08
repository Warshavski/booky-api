# frozen_string_literal: true

# Genre
#
#   Represents book genre
#
class Genre < ApplicationRecord
  include Searchable

  has_many :books_genres, dependent: :destroy
  has_many :books, through: :books_genres

  before_save -> { name.downcase! }
end
