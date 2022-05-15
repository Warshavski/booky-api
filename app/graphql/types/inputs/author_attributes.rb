# frozen_string_literal: true

module Types
  module Inputs
    # Types::Inputs::AuthorAttributes
    #
    # TODO : consider to move it to the separate authors namespace
    #
    class AuthorAttributes < BaseInputObject
      description 'Input with author attributes.'

      argument :first_name, GraphQL::Types::String,
               required: true,
               description: 'First name of the author.'

      argument :last_name, GraphQL::Types::String,
               required: true,
               description: 'Last name of the author.'

      argument :biography, GraphQL::Types::String,
               required: false,
               description: "Author's biography."

      argument :born_in, GraphQL::Types::ISO8601Date,
               required: false,
               description: "Author's birthday date"

      argument :died_in, GraphQL::Types::ISO8601Date,
               required: false,
               description: "Author's death date."

      argument :book_ids, [GraphQL::Types::ID],
               required: false,
               description: 'IDs of books written by the author.'
    end
  end
end
