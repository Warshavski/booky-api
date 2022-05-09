# frozen_string_literal: true

module Resolvers
  module Lists
    # Resolvers::Lists::AuthorsResolver
    #
    class AuthorsResolver < GraphQL::Schema::Resolver
      description 'Collection of Authors.'

      argument :sort, GraphQL::Types::String,
               description: "Sort criteria(example: '-name,id').",
               required: false

      argument :search, GraphQL::Types::String,
               description: 'Search query for first name or last name.',
               required: false

      argument :book_id, ID,
               description: 'Filter authors by book ID.',
               required: false

      def resolve(**args)
        AuthorsQuery.call(params: args)
      end
    end
  end
end
