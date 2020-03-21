# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book author model
    #
    class AuthorType < BaseModelObject
      field :first_name,  String, null: false
      field :last_name,   String, null: false
      field :biography,   String, null: true

      field :born_in, ::GraphQL::Types::ISO8601Date, null: true
      field :died_in, ::GraphQL::Types::ISO8601Date, null: true

      field :books, [Types::Models::BookType], null: true
    end
  end
end
