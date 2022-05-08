# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book model
    #
    class BookType < BaseObject
      implements Interfaces::ModelInterface

      description 'Book in the library.'

      field :title, String,
            null: false,
            description: 'Name of the book.'

      field :description, String,
            null: true,
            description: 'Book description(what its about).'

      field :isbn13, String,
            null: true,
            description: 'The International Standard Book Number (ISBN) is '\
                         'a numeric commercial book identifier that is intended to '\
                         'be unique. Publishers purchase ISBNs from an affiliate of '\
                         'the International ISBN Agency.'

      field :isbn10, String,
            null: true,
            description: 'The International Standard Book Number (ISBN) is '\
                         'a numeric commercial book identifier that is intended to '\
                         'be unique. Publishers purchase ISBNs from an affiliate of '\
                         'the International ISBN Agency.'

      field :weight, Integer,
            null: true,
            description: 'Book weigh(grams)'

      field :pages_count, Integer,
            null: false,
            description: ''

      field :published_at, ::GraphQL::Types::ISO8601Date,
            null: false,
            description: 'Book publication date'

      field :publisher, Types::Models::PublisherType,
            null: false,
            description: 'How published book'

      field :authors, [Types::Models::AuthorType],
            null: true,
            description: 'Book authors list'

      field :genres, [Types::Models::GenreType],
            null: true,
            description: 'Book genres list'
    end
  end
end
