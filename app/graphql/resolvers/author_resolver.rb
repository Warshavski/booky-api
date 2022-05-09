# frozen_string_literal: true

module Resolvers
  # Resolvers::AuthorResolver
  #
  class AuthorResolver < GraphQL::Schema::Resolver
    description 'Fetch Author by ID'

    argument :id, ID,
             description: 'Author unique identity.',
             required: true

    def resolve(id:)
      Author.find(id)
    end
  end
end
