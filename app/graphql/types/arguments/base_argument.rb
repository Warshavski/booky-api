# frozen_string_literal: true

module Types
  # Types::BaseArgument
  #
  #   Fields can take arguments as input.
  #   These can be used to determine the return value (eg, filtering search results) or
  #     to modify the application state (eg, updating the database in MutationType).
  #
  #   Arguments are defined with the "argument" helper.
  #
  # @see https://graphql-ruby.org/fields/arguments.html
  #
  class BaseArgument < GraphQL::Schema::Argument
  end
end
