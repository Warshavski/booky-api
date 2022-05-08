# frozen_string_literal: true

module Types
  # Type::MutationType
  #
  #   Operations that begin with mutation get special treatment by the GraphQL runtime:
  #     root fields are guaranteed to be executed sequentially.
  #   This way, the effect of a series of mutations is predictable.
  #
  #   Mutations are executed by a specific GraphQL object, Mutation.
  #
  # @see https://graphql-ruby.org/mutations/mutation_root.html
  #
  class MutationType < Types::BaseObject
    field :create_genre,
          mutation: Mutations::Genres::Create,
          description: 'Creates a new genre.'
  end
end
