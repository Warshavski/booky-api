# frozen_string_literal: true.

module Books
  # BookSerializer
  #
  #   Used for the book data representation
  #     (core attributes)
  #
  class CoreSerializer
    include FastJsonapi::ObjectSerializer

    set_type :book

    attributes :title, :description, :weight,
               :pages_count, :isbn_13, :isbn_10,
               :published_at, :created_at, :updated_at
  end
end
