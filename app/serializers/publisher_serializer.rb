# frozen_string_literal: true.

# PublisherSerializer
#
#   Used for the publisher data representation
#
class PublisherSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :description, :phone,
             :address, :email, :postcode,
             :created_at, :updated_at
end
