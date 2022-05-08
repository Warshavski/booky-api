# frozen_string_literal: true

module Resolvers
  # Resolvers::BooksResolver
  #
  class BooksResolver < GraphQL::Schema::Resolver
    argument :sort, GraphQL::Types::String,
             description: 'Sort books by this criteria.',
             required: false

    argument :search, GraphQL::Types::String,
             description: 'Search query for title.',
             required: false

    def resolve(**args)
      BooksQuery.call(params: args)
    end
  end
end
