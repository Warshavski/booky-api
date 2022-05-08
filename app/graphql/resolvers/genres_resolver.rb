# frozen_string_literal: true

module Resolvers
  # Resolvers::GenresResolver
  #
  class GenresResolver < GraphQL::Schema::Resolver
    argument :sort, GraphQL::Types::String,
             description: "Sort criteria(example: '-name,id').",
             required: false

    argument :search, GraphQL::Types::String,
             description: 'Search query for name.',
             required: false

    def resolve(**args)
      GenresQuery.call(params: args)
    end
  end
end
