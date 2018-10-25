# frozen_string_literal: true.

# AuthorSerializer
#
#   Used for the author data representation
#
class AuthorSerializer
  include FastJsonapi::ObjectSerializer

  attributes :biography, :first_name, :last_name,
             :born_in, :died_in, :created_at, :updated_at
end
