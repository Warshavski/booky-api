# frozen_string_literal: true.

# BookSerializer
#
#   Used for the book data representation
#
class BookSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description, :weight,
             :pages_count, :isbn_13, :isbn_10,
             :published_at, :created_at, :updated_at
end
