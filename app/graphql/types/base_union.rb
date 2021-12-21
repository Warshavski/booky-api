# frozen_string_literal: true

module Types
  # Types::BaseUnion
  #
  #   A union type is a set of object types which may appear in the same spot.
  #
  # @see https://graphql-ruby.org/type_definitions/unions.html
  #
  class BaseUnion < GraphQL::Schema::Union
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
  end
end
