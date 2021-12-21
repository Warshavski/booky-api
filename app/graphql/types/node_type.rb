# frozen_string_literal: true

module Types
  # Types::NodeType
  #
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
