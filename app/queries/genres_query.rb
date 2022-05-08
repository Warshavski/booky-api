# frozen_string_literal: true

# GenresQuery
#
#   Used to search, filter, and sort the collection of genres (@see Genre)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class GenresQuery < ApplicationQuery
  options default_scope: Genre.all

  specify_filter(:search) do |items, filter_value|
    items.fuzzy_search(filter_value, %i[name])
  end

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :search   Search pattern(part of the name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  #
  def initialize(context:, params:)
    super(context: context, params: params)
  end
end
