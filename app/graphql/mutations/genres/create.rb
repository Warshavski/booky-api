# frozen_string_literal: true

module Mutations
  module Genres
    # Mutations::Genres::Create
    #
    class Create < BaseMutation
      null true

      argument :name, GraphQL::Types::String,
               required: true,
               description: 'Name of the genre, such as sci-fi, thriller, e.t.c.'

      argument :description, GraphQL::Types::String,
               required: false,
               description: 'Description of the genre.'

      field :genre, Types::Models::GenreType

      def resolve(name:, description: nil)
        input = { name: name, description: description }

        execute(::Genres::Create, input: input, root: :genre)
      end
    end
  end
end
