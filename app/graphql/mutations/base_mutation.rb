# frozen_string_literal: true

module Mutations
  # Mutations::BaseMutation
  #
  # TODO : add description from documentation
  #
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end
end
