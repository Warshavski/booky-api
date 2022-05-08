# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book model
    #
    class BookType < BaseObject
      implements Interfaces::ModelInterface

      field :title,         String,   null: false
      field :description,   String,   null: true
      field :isbn13,        String,   null: true
      field :isbn10,        String,   null: true
      field :weight,        Integer,  null: true
      field :pages_count,   Integer,  null: false

      field :published_at,  ::GraphQL::Types::ISO8601Date, null: false

      field :publisher, Types::Models::PublisherType, null: false

      field :authors, [Types::Models::AuthorType],  null: true
      field :genres,  [Types::Models::GenreType],   null: true
    end
  end
end
