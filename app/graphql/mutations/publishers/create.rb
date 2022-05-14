# frozen_string_literal: true

module Mutations
  module Publishers
    # Mutations::Publishers::Create
    #
    class Create < BaseMutation
      graphql_name 'CreatePublisher'

      description 'Create new Publisher.'

      null true

      argument :attributes, Types::Inputs::PublisherAttributes,
               required: true, description: 'Publisher attributes.'

      field :publisher, Types::Models::PublisherType, description: 'Book publisher.'

      def resolve(attributes:)
        execute(::Publishers::Create, input: attributes, root: :publisher)
      end
    end
  end
end
