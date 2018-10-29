# frozen_string_literal: true.

# GenreSerializer
#
#   Used for the genre data representation
#
class GenreSerializer
  include FastJsonapi::ObjectSerializer

  attribute :name
end
