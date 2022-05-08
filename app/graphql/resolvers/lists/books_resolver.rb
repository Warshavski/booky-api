# frozen_string_literal: true

module Resolvers
  module Lists
    # Resolvers::Lists::BooksResolver
    #
    class BooksResolver < GraphQL::Schema::Resolver
      argument :sort, GraphQL::Types::String,
               description: 'Sort books by this criteria.',
               required: false

      argument :search, GraphQL::Types::String,
               description: 'Search query for title.',
               required: false

      argument :publisher_id, GraphQL::Types::BigInt,
               description: 'Filter books by publisher.',
               required: false

      argument :author_id, GraphQL::Types::BigInt,
               description: 'Filter books by author.',
               required: false

      argument :genre_ids, [GraphQL::Types::BigInt],
               description: 'Filter books by genres.',
               required: false

      argument :publish_date, GraphQL::Types::String,
               description: 'Filter books by publication date(year or exact date).',
               required: false

      argument :isbn, GraphQL::Types::String,
               description: 'Filter books by isbn(isbn-13 or isbn-10.',
               required: false

      def resolve(**args)
        BooksQuery.call(params: args)
      end
    end
  end
end
