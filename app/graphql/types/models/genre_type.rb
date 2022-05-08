# frozen_string_literal: true

module Types
  module Models
    # Types::Models::BookType
    #
    #   Represents book genre model
    #
    class GenreType < BaseObject
      implements Interfaces::ModelInterface

      description 'Books genre'

      field :name, String,
            null: false,
            description: 'Name of the genre.'

      field :description, String,
            null: true,
            description: 'Description of the genre.'

      field :books, Types::Models::BookType.connection_type,
            null: true,
            description: 'Books list of this genre'
    end
  end
end
