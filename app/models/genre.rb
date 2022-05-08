# frozen_string_literal: true

# Genre
#
#   Represents book genre
#
class Genre < ApplicationRecord
  include Searchable

  has_and_belongs_to_many :books

  before_save -> { name.downcase! }
end
