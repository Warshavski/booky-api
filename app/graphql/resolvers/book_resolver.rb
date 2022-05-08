# frozen_string_literal: true

module Resolvers
  # Resolvers::BookResolver
  #
  class BookResolver < GraphQL::Schema::Resolver
    argument :id, ID,
             description: 'Book unique identity.',
             required: true

    def resolve(id:)
      Book.find(id)
    end
  end
end
