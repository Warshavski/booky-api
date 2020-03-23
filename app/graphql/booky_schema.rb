# frozen_string_literal: true

# BookySchema
#
#   The schema declares that all the queries should go to Types::QueryType
#     while mutations should go to Types::MutationType.
#
# @see https://graphql-ruby.org/schema/definition.html
#
class BookySchema < GraphQL::Schema
  use GraphQL::Pagination::Connections

  mutation(Types::MutationType)
  query(Types::QueryType)
end
