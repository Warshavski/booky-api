# frozen_string_literal: true

module Mutations
  # Mutations::BaseMutation
  #
  #   This base class accepts configuration for a mutation root field,
  #   then it can be hooked up to your mutation root object type.
  #
  #   If you want to customize how this class generates types,
  #   in your base class, override the various generate_* methods.
  #
  # @see https://graphql-ruby.org/mutations/mutation_classes.html
  #
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class      Types::BaseArgument
    field_class         Types::BaseField
    input_object_class  Types::BaseInputObject
    object_class        Types::BaseObject

    field :errors, [Types::Errors::InputErrorType],
          null: false,
          description: 'Errors encountered during execution of the mutation.'

    def execute(interactor_klass, input:, root:)
      result = interactor_klass.call(params: input)

      if result.success?
        { root => result.object, errors: [] }
      else
        { root => nil, errors: result.errors }
      end
    end
  end
end
