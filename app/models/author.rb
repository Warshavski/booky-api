# frozen_string_literal: true

# Author
#
#   Represents the creator or originator of the book
#
class Author < ApplicationRecord
  include Searchable

  has_and_belongs_to_many :books

  validates :first_name, :last_name, presence: true
end
