# frozen_string_literal: true

# PublishersQuery
#
#   Used to search, filter, and sort the collection of publishers
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class PublishersQuery < ApplicationQuery
  options default_scope: Publisher.all

  filtering(:search) do |items, filter_value|
    items.fuzzy_search(filter_value, %i[name])
  end

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :sort     sort type(attribute and sort direction)
  # @option params [String]   :search   search pattern(part of the name)
  #
  def initialize(context: nil, params: nil)
    super(context: context, params: params)
  end
end
