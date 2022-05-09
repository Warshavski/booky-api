# frozen_string_literal: true

module Resolvers
  module Lists
    # Resolvers::Lists::PublishersResolver
    #
    class PublishersResolver < GraphQL::Schema::Resolver
      description 'Collection of Publishers.'

      argument :sort, GraphQL::Types::String,
               description: "Sort criteria(example: '-name,id').",
               required: false

      argument :search, GraphQL::Types::String,
               description: 'Search query for name.',
               required: false

      def resolve(**args)
        PublishersQuery.call(params: args)
      end
    end
  end
end
