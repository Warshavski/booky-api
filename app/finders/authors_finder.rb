# frozen_string_literal: true

# AuthorsFinder
#
#   Used to search, filter, and sort the collection of authors (@see Author)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class AuthorsFinder

  attr_reader :params

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [Integer]  :book_id  Book identifier written by the author
  # @option params [String]   :search   Search pattern(part of the first or last name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  #
  def initialize(params = {})
    @params = params
  end

  def execute
    collection = Author

    collection = filter_by_book(collection)
    collection = filter_by_search(collection)

    sort(collection)
  end

  private

  def filter_by_book(items)
    return items if params[:book_id].blank?

    items.joins(:books).where(books: { id: params[:book_id] })
  end

  def filter_by_search(items)
    params[:search].present? ? items.search(params[:search]) : items
  end

  def sort(items)
    params[:sort].present? ? items.order_by(params[:sort]) : items.order_by(:created_asc)
  end
end
