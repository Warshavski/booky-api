# frozen_string_literal: true

# AuthorsQuery
#
#   Used to search, filter, and sort collection of authors (@see Author)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class AuthorsQuery < ApplicationQuery
  options default_scope: Author.all

  specify_filter(:book_id) do |items, filter_value|
    items.joins(:books).merge(Book.where(id: filter_value))
  end

  specify_filter(:search) do |items, filter_value|
    items.fuzzy_search(filter_value, %i[first_name last_name])
  end

  # @option params [Integer]  :book_id  Book identifier written by the author
  # @option params [String]   :search   Search pattern(part of the first or last name)
  # @option params [String]   :sort     Sort type(attribute and sort direction)
  #
  def initialize(context:, params:)
    super(context: context, params: params)
  end
end
