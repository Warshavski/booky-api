# frozen_string_literal: true

module Types
  module Models
    # Types::Models::PublisherType
    #
    #   Represents book publisher model
    #
    class PublisherType < BaseObject
      implements Interfaces::ModelInterface

      description 'Books publisher'

      field :name, String,
            null: false,
            description: 'Publisher name.'

      field :description, String,
            null: true,
            description: 'Publisher description.'

      field :email, String,
            null: true,
            description: 'Contact email address of the publisher.'

      field :phone, String,
            null: true,
            description: 'Contact phone number of the publisher.'

      field :address, String,
            null: true,
            description: 'Address of the publisher.'

      field :postcode, String,
            null: true,
            description: 'Postal code of the publisher.'

      field :books, Types::Models::BookType.connection_type,
            null: true,
            description: 'List of book owned by this publisher.'
    end
  end
end
