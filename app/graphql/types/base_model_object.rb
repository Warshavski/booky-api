# frozen_string_literal: true

module Types
  # Types::BaseModelObject
  #
  #   Contains common fields and logic across all models
  #
  class BaseModelObject < Types::BaseObject
    field :id, ID, null: false

    field :created_at, ::GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, ::GraphQL::Types::ISO8601DateTime, null: false
  end
end
