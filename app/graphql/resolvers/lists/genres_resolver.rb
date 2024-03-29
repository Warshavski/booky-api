# frozen_string_literal: true

module Resolvers
  module Lists
    # Resolvers::Lists::GenresResolver
    #
    class GenresResolver < GraphQL::Schema::Resolver
      description 'Collection of Genres.'

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
end
