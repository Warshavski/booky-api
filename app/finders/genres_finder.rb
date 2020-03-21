# frozen_string_literal: true

# GenresFinder
#
#   Used to search, filter, and sort the collection of genres (@see Genre)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class GenresFinder < BaseFinder
  filter(:search) do |items, params|
    params[:search].present? ? items.search(params[:search]) : items
  end

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :search   Search pattern(part of the name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  #
  def initialize(params = {})
    super
    @collection = Genre
  end
end
