# frozen_string_literal: true

# Publisher
#
#   Represents a publisher of books
#
class Publisher < ApplicationRecord
  include CaseSensible
  include Searchable

  has_many :books, dependent: :restrict_with_exception
end
