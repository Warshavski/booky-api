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
    # TODO: remove me
    field :test_field, String, null: false,
                               description: 'An example field added by the generator'
    def test_field
      'Hello World'
    end
  end
end
