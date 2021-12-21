# frozen_string_literal: true

module Types
  # Types::BaseInputObject
  #
  #   Input object types are complex inputs for GraphQL operations.
  #   They're great for fields that need a lot of structured input, like mutations or search fields.
  #
  # @see https://graphql-ruby.org/type_definitions/input_objects.html
  #
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
end
