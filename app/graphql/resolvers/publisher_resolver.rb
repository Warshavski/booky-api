# frozen_string_literal: true

module Resolvers
  # Resolvers::PublisherResolver
  #
  class PublisherResolver < GraphQL::Schema::Resolver
    description 'Fetch Publisher by ID'

    argument :id, ID,
             description: 'Publisher unique identity.',
             required: true

    def resolve(id:)
      Publisher.find(id)
    end
  end
end
