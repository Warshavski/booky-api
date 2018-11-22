# frozen_string_literal: true

# PublishersFinder
#
#   Used to search, filter, and sort the collection of publishers
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class PublishersFinder
  include PaginationFilters

  attr_reader :params

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :sort     sort type(attribute and sort direction)
  # @option params [String]   :search   search pattern(part of the name)
  # @option params [Integer]  :page     page number
  # @option params [Integer]  :limit    quantity of items per page
  #
  def initialize(params = {})
    @params = params
  end

  def execute
    collection = Publisher

    collection = filter_by_search(collection)

    collection = filter_by_limit(collection)
    collection = paginate_items(collection)

    sort(collection)
  end

  private

  def filter_by_search(items)
    params[:search].present? ? items.search(params[:search]) : items
  end

  def sort(items)
    params[:sort].present? ? items.order_by(params[:sort]) : items.order_by(:created_asc)
  end
end
