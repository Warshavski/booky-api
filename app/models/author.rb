# frozen_string_literal: true

# Author
#
#   Represents the creator or originator of the book
#
class Author < ApplicationRecord
  include Searchable

  has_many :books_authors, dependent: :destroy
  has_many :books, through: :books_authors

  validates :first_name, :last_name, presence: true
end
