# frozen_string_literal: true

module Types
  # Types::BaseField
  #
  #   Object fields expose data about that object or connect the object to other objects.
  #   You can add fields to your object types with the field(...) class method.
  #
  # @see https://graphql-ruby.org/fields/introduction.html
  #
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def resolve_field(obj, args, ctx)
      resolve(obj, args, ctx)
    end
  end
end
