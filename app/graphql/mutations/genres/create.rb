# frozen_string_literal: true

module Mutations
  module Genres
    # Mutations::Genres::Create
    #
    class Create < BaseMutation
      graphql_name 'CreateGenre'

      description 'Create new Genre.'

      null true

      argument :attributes, Types::Inputs::GenreAttributes,
               required: true, description: 'Genre attributes.'

      field :genre, Types::Models::GenreType, description: 'Book genre.'

      def resolve(attributes:)
        execute(::Genres::Create, input: attributes, root: :genre)
      end
    end
  end
end
