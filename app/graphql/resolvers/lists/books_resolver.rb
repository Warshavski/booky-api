# frozen_string_literal: true

module Resolvers
  module Lists
    # Resolvers::Lists::BooksResolver
    #
    class BooksResolver < GraphQL::Schema::Resolver
      description 'Collection of Books.'

      argument :sort, GraphQL::Types::String,
               required: false,
               description: 'Sort books by this criteria.'

      argument :search, GraphQL::Types::String,
               required: false,
               description: 'Search query for title.'

      argument :publisher_id, ID,
               required: false,
               description: 'Filter books by publisher.'

      argument :author_id, ID,
               required: false,
               description: 'Filter books by author.'

      argument :genre_ids, [ID],
               required: false,
               description: 'Filter books by genres.'

      argument :publish_date, GraphQL::Types::String,
               required: false,
               description: 'Filter books by publication date(year or exact date).'

      argument :isbn, GraphQL::Types::String,
               required: false,
               description: 'Filter books by isbn(isbn-13 or isbn-10.'

      def resolve(**args)
        BooksQuery.call(params: args)
      end
    end
  end
end
