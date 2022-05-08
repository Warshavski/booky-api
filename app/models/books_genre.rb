# frozen_string_literal: true

# BooksGenre
#
#   Represents connection between book and genre
#
class BooksGenre < ApplicationRecord
  belongs_to :book
  belongs_to :genre
end
