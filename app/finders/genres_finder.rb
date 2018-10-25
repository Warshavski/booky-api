# frozen_string_literal: true

# GenresFinder
#
#   Used to search, filter, and sort the collection of genres (@see Genre)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class GenresFinder

  attr_reader :params

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [String]   :search   Search pattern(part of the name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  #
  def initialize(params = {})
    @params = params
  end

  def execute
    collection = Genre

    collection = filter_by_search(collection)

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
