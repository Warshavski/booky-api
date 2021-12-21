# frozen_string_literal: true

module Types
  # Types::BaseEnum
  #
  #   Enum types are sets of discrete values.
  #   An enum field must return one of the possible values of the enum.
  #
  # @see https://graphql-ruby.org/type_definitions/enums.html
  #
  class BaseEnum < GraphQL::Schema::Enum
  end
end
