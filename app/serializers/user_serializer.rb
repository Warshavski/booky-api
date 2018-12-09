# frozen_string_literal: true.

# UserSerializer
#
#   Used for the user data representation
#
class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :email, :username, :created_at, :updated_at

  attribute :avatar_url do |object|
    object.avatar_url || GravatarGenerator.new.execute(object.email, 100, 2, username: object.username)
  end
end

