# frozen_string_literal: true

module Mutations
  module Authors
    # Mutations::Authors::Update
    #
    class Update < BaseMutation
      graphql_name 'UpdateAuthor'

      description 'Update existing Author.'

      null true

      argument :id, ID,
               required: true, description: 'ID of the author to update.'

      argument :attributes, Types::Inputs::AuthorAttributes,
               required: true, description: 'Author attributes.'

      field :author, Types::Models::AuthorType, description: 'Book author.'

      def resolve(id:, attributes:)
        execute(::Authors::Update, id: id, input: attributes, root: :author)
      end
    end
  end
end
