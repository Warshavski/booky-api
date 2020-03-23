# frozen_string_literal: true

module Types
  module Models
    # Types::Models::PublisherType
    #
    #   Represents book publisher model
    #
    class PublisherType < BaseModelObject
      field :name,          String, null: false
      field :description,   String, null: true
      field :email,         String, null: true
      field :phone,         String, null: true
      field :address,       String, null: true
      field :postcode,      String, null: true

      field :books, Types::Models::BookType.connection_type, null: true
    end
  end
end
