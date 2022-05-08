# frozen_string_literal: true

module Types
  # Types::QueryType
  #
  #   Entry point for all the queries.
  #
  # Add root-level fields here.
  # They will be entry points for queries on your schema.
  #
  # @see https://graphql-ruby.org/queries/executing_queries.html
  #
  class QueryType < Types::BaseObject
    field :authors,
          Types::Models::AuthorType.connection_type,
          null: true,
          description: 'Returns a list of books authors'

    field :books,
          Types::Models::BookType.connection_type,
          null: true,
          description: 'Returns a list of books in the library',
          resolver: Resolvers::BooksResolver

    field :genres,
          Types::Models::GenreType.connection_type,
          null: true,
          description: 'Returns a list of books genres'

    field :publishers,
          Types::Models::PublisherType.connection_type,
          null: true,
          description: 'Returns a list of the books publishers'

    def authors
      Author.all
    end

    def genres
      Genre.all
    end

    def publishers
      Publisher.all
    end
  end
end
