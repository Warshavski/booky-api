# frozen_string_literal: true

# BookyApiSchema
#
#   The schema declares that all the queries should go to Types::QueryType
#     while mutations should go to Types::MutationType.
#
# @see https://graphql-ruby.org/schema/definition.html
#
class BookyApiSchema < GraphQL::Schema
  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  mutation(Types::MutationType)
  query(Types::QueryType)

  default_max_page_size 100

  validate_max_errors 5
  validate_timeout 0.2.seconds

  # GraphQL-Ruby calls this when something goes wrong while running a query:

  class << self
    # Union and Interface Resolution
    def resolve_type(_abstract_type, _obj, _ctx)
      # TODO: Implement this method
      # to return the correct GraphQL object type for `obj`
      raise(GraphQL::RequiredImplementationMissingError)
    end

    # Relay-style Object Identification:

    # Return a string UUID for `object`
    def id_from_object(object, type_definition, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      object_id = object.to_global_id.to_s
      # Remove this redundant prefix to make IDs shorter:
      object_id = object_id.sub("gid://#{GlobalID.app}/", '')
      encoded_id = Base64.urlsafe_encode64(object_id)
      # Remove the "=" padding
      encoded_id = encoded_id.sub(/=+/, '')
      # Add a type hint
      type_hint = type_definition.graphql_name.first
      "#{type_hint}_#{encoded_id}"
    end

    # Given a string UUID, find the object
    def object_from_id(encoded_id_with_hint, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      # Split off the type hint
      _type_hint, encoded_id = encoded_id_with_hint.split('_', 2)
      # Decode the ID
      id = Base64.urlsafe_decode64(encoded_id)
      # Rebuild it for Rails then find the object:
      full_global_id = "gid://#{GlobalID.app}/#{id}"
      GlobalID::Locator.locate(full_global_id)
    end
  end
end
