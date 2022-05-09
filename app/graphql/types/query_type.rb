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
    description 'Query entry point. Root-level queries list.'

    field :author, Types::Models::AuthorType,
          null: true,
          resolver: Resolvers::AuthorResolver,
          description: 'Returns author selected by provided ID.'

    field :authors, Types::Models::AuthorType.connection_type,
          null: true,
          resolver: Resolvers::Lists::AuthorsResolver,
          description: 'Returns a list of books authors.'

    field :book, Types::Models::BookType,
          null: false,
          resolver: Resolvers::BookResolver,
          description: 'Returns book selected by provided ID.'

    field :books, Types::Models::BookType.connection_type,
          null: true,
          resolver: Resolvers::Lists::BooksResolver,
          description: 'Returns a list of books in the library.'

    field :genre, Types::Models::GenreType,
          null: false,
          resolver: Resolvers::GenreResolver,
          description: 'Returns genre selected by provided ID.'

    field :genres, Types::Models::GenreType.connection_type,
          null: true,
          resolver: Resolvers::Lists::GenresResolver,
          description: 'Returns a list of books genres.'

    field :publisher, Types::Models::PublisherType,
          null: true,
          resolver: Resolvers::PublisherResolver,
          description: 'Returns genre selected by provided ID.'

    field :publishers, Types::Models::PublisherType.connection_type,
          null: true,
          resolver: Resolvers::Lists::PublishersResolver,
          description: 'Returns a list of the books publishers.'
  end
end
