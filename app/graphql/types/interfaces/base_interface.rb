# frozen_string_literal: true

module Types
  # Types::BaseInterface
  #
  #   Interfaces are lists of fields which may be implemented by object types.
  #
  #   An interface has fields, but it's never actually instantiated.
  #   Instead, objects may implement interfaces, which makes them a member of that interface.
  #   Also, fields may return interface types. When this happens, the returned object may be any member of that interface.
  #
  #   For example, let's say a Customer (interface) may be either an Individual (object) or a Company (object).
  #
  # @see https://graphql-ruby.org/type_definitions/interfaces.html
  #
  module BaseInterface
    include GraphQL::Schema::Interface
  end
end
