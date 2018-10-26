# frozen_string_literal: true.

module Books
  # BookDetailedSerializer
  #
  #   Used for the book data representation
  #     (detailed information)
  #
  class DetailedSerializer < CoreSerializer
    has_many :authors, serializer: AuthorSerializer
    has_many :genres, serializer: GenreSerializer
  end
end
