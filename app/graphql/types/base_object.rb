# frozen_string_literal: true

module Types
  # Types::BaseObject
  #
  #   GraphQL object types are the bread and butter of GraphQL APIs.
  #   Each object has fields which expose data and may be queried by name.
  #
  #   Generally speaking, GraphQL object types correspond to models in your application.
  #
  # @see https://graphql-ruby.org/type_definitions/objects.html
  #
  class BaseObject < GraphQL::Schema::Object
  end
end
