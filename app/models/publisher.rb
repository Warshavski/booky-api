# frozen_string_literal: true

# Publisher
#
#   Represents a publisher of books
#
class Publisher < ApplicationRecord
  include Searchable

  has_many :books, dependent: :restrict_with_exception

  validates :name, presence: true
end
