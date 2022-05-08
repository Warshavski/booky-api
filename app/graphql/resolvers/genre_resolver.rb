# frozen_string_literal: true

module Resolvers
  # Resolvers::GenreResolver
  #
  class GenreResolver < GraphQL::Schema::Resolver
    description 'Fetch Genre by ID'

    argument :id, ID,
             description: 'Genre unique identity.',
             required: true

    def resolve(id:)
      Genre.find(id)
    end
  end
end
