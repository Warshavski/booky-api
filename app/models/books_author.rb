# frozen_string_literal: true

# BooksAuthor
#
#   Represents connection between book and author
#
class BooksAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author
end
