# frozen_string_literal: true

module Types
  module Inputs
    # Types::Inputs::GenreAttributes
    #
    # TODO : consider to move it to the separate genre namespace
    #
    class GenreAttributes < BaseInputObject
      description 'Input with genre attributes'

      argument :name, GraphQL::Types::String,
               required: true,
               description: 'Name of the genre, such as sci-fi, thriller, e.t.c.'

      argument :description, GraphQL::Types::String,
               required: false,
               description: 'Description of the genre.'
    end
  end
end
