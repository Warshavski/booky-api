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
    class << self
      def mount_mutation(mutation_class, **custom_kwargs)
        # Using an underscored field name symbol will make `graphql-ruby`
        #   standardize the field name
        #
        field mutation_class.graphql_name.underscore.to_sym,
              mutation: mutation_class,
              **custom_kwargs
      end
    end

    description 'Mutations root-level.'

    mount_mutation Mutations::Authors::Create, description: 'Creates a new author.'
    mount_mutation Mutations::Authors::Update, description: 'Updates an existing author.'

    mount_mutation Mutations::Genres::Create,     description: 'Creates a new genre.'
    mount_mutation Mutations::Publishers::Create, description: 'Creates a new publisher.'
  end
end
