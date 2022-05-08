# frozen_string_literal: true

module Types
  module Interfaces
    # Types::Interfaces::ApplicationModelInterface
    #
    #   Contains common fields and across all application models
    #
    module ModelInterface
      include Types::BaseInterface

      description 'Model precursor'

      field :id, ID, null: false, description: 'Model identity.'

      field :created_at, ::GraphQL::Types::ISO8601DateTime,
            null: false,
            description: 'Model create timestamp(ISO8601).'

      field :updated_at, ::GraphQL::Types::ISO8601DateTime,
            null: false,
            description: 'Model last update timestamp(ISO8601).'
    end
  end
end
