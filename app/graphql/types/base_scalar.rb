# frozen_string_literal: true

module Types
  # Types::BaseScalar
  #
  #   Scalars are "leaf" values in GraphQL.
  #   There are several built-in scalars, and you can define custom scalars, too.
  #   (Enums are also leaf values.)
  #
  #   The built-in scalars are:
  #
  #     - String,           like a JSON or Ruby string
  #     - Int,              like a JSON or Ruby integer
  #     - Float,            like a JSON or Ruby floating point decimal
  #     - Boolean,          like a JSON or Ruby boolean (true or false)
  #     - ID,               which a specialized String for representing unique object identifiers
  #     - ISO8601DateTime,  an ISO 8601-encoded datetime
  #     - ISO8601Date,      an ISO 8601-encoded date
  #
  #     - JSON, This returns arbitrary JSON (Ruby hashes, arrays, strings, integers, floats, booleans and nils).
  #             Take care: by using this type, you completely lose all GraphQL type safety.
  #              Consider building object types for your data instead.
  #
  # @see https://graphql-ruby.org/type_definitions/scalars.html
  #
  class BaseScalar < GraphQL::Schema::Scalar
  end
end
