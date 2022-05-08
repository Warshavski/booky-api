# frozen_string_literal: true

module Types
  module Errors
    # Types::Errors::InputErrorType
    #
    #   Used to represent contract validation error
    #
    class InputErrorType < Types::BaseObject
      description 'A user-readable error.'

      field :code, Int,
            null: false,
            description: 'HTTP status code.'

      field :path, [String],
            description: 'Which input value this error came from.',
            null: false

      field :message, String,
            description: 'A detailed error description.',
            null: false
    end
  end
end
