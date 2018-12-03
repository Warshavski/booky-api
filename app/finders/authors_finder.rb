# frozen_string_literal: true

# AuthorsFinder
#
#   Used to search, filter, and sort the collection of authors (@see Author)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class AuthorsFinder < BaseFinder
  include PaginationFilters

  filter(:book_id) do |items, params|
    if params[:book_id].present?
      items.joins(:books).merge(Book.where(id: params[:book_id]))
    else
      items
    end
  end

  filter(:search) do |items, params|
    params[:search].present? ? items.search(params[:search]) : items
  end

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [Integer]  :book_id  Book identifier written by the author
  # @option params [String]   :search   Search pattern(part of the first or last name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  # @option params [Integer]  :page     Page number
  # @option params [Integer]  :limit    Quantity of items per page
  #
  def initialize(params = {})
    super
    @collection = Author
  end
end
