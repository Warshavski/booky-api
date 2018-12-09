# frozen_string_literal: true

# Sale
#
#   Represents a report on the sale of a book copies in a particular store
#
class Sale < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  validates :book, :shop, presence: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
