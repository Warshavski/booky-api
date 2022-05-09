# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book author model
    #
    class AuthorType < BaseObject
      implements Interfaces::ModelInterface

      description 'Book author.'

      field :first_name, String,
            description: 'Author first name.',
            null: false

      field :last_name, String,
            description: 'Author last name.',
            null: false

      field :biography, String,
            description: 'Author biography.',
            null: true

      field :born_in, ::GraphQL::Types::ISO8601Date,
            description: 'Author birthday date.',
            null: true

      field :died_in, ::GraphQL::Types::ISO8601Date,
            description: 'Author date of death.',
            null: true

      field :books, Types::Models::BookType.connection_type,
            description: 'Collection of books written by the author.',
            null: true
    end
  end
end
