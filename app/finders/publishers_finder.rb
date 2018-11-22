# frozen_string_literal: true

# PublishersFinder
#
#   Used to search, filter, and sort the collection of publishers
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class PublishersFinder < BaseFinder
  include PaginationFilters

  filter(:search) do |items, params|
    params[:search].present? ? items.search(params[:search]) : items
  end

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :sort     sort type(attribute and sort direction)
  # @option params [String]   :search   search pattern(part of the name)
  # @option params [Integer]  :page     page number
  # @option params [Integer]  :limit    quantity of items per page
  #
  def initialize(params = {})
    super
    @collection = Publisher
  end
end
