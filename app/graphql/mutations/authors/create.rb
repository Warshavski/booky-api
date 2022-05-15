# frozen_string_literal: true

module Mutations
  module Authors
    # Mutations::Authors::Create
    #
    class Create < BaseMutation
      graphql_name 'CreateAuthor'

      description 'Create new a Author.'

      null true

      argument :attributes, Types::Inputs::AuthorAttributes,
               required: true, description: 'Author attributes.'

      field :author, Types::Models::AuthorType, description: 'Book author.'

      def resolve(attributes:)
        execute(::Authors::Create, input: attributes, root: :author)
      end
    end
  end
end
