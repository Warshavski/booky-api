# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book genre model
    #
    class GenreType < BaseModelObject
      field :name, String, null: false

      field :books, Types::Models::BookType.connection_type, null: true
    end
  end
end
