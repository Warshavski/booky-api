# frozen_string_literal: true

module Types
  module Inputs
    # Types::Inputs::PublisherAttributes
    #
    # TODO : consider to move it to the separate publishers namespace
    #
    class PublisherAttributes < BaseInputObject
      description 'Input with publisher attributes'

      argument :name, GraphQL::Types::String,
               required: true,
               description: 'Name of the publisher, such as sci-fi, thriller, e.t.c.'

      argument :email, GraphQL::Types::String,
               required: false,
               description: 'Contact email of the publisher.'

      argument :phone, GraphQL::Types::String,
               required: false,
               description: 'Contact phone number of the publisher.'

      argument :postcode, GraphQL::Types::String,
               required: false,
               description: 'Address postcode of the publisher.'

      argument :address, GraphQL::Types::String,
               required: false,
               description: 'Address of the publisher.'

      argument :description, GraphQL::Types::String,
               required: false,
               description: 'Description of the publisher.'
    end
  end
end
