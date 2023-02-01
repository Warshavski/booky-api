# frozen_string_literal: true

# BooksQuery
#
#   Used to search, filter, and sort collection of books (@see Book)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class BooksQuery < ApplicationQuery
  options default_scope: Book.all

  specify_filter(:search) do |items, filter_value|
    items.fuzzy_search(filter_value, %i[title])
  end

  specify_filter(:publisher_id) do |items, filter_value|
    items.where(publisher_id: filter_value)
  end

  specify_filter(:author_id) do |items, filter_value|
    items.joins(:authors).merge(Author.where(id: filter_value))
  end

  specify_filter(:genre_ids) do |items, filter_value|
    items.joins(:genres).merge(Genre.where(id: filter_value)).distinct
  end

  specify_filter(:publish_date) do |items, filter_value|
    publish_date = ApplicationRecord.sanitize_sql_like(filter_value.to_s)

    if publish_date.length > 4
      items.where(published_in: publish_date)
    else
      # looks legit
      items.where('published_in between ? and ?', "#{publish_date}-01-01", "#{publish_date}-12-31")
    end
  end

  specify_filter(:isbn) do |items, filter_value|
    items.by_isbn(isbn10: filter_value, isbn13: filter_value)
  end

  # @overload #initialize(context, params)
  #
  # @param context [Book]  scope of the books (default: Book.all)
  # @param params [Hash] (optional, default: {}) specify_filter and sort parameters
  #
  # @option params [Integer]        :publisher_id   Publisher identity
  # @option params [Integer]        :author_id      Book author identity
  # @option params [Array<Integer>] :genre_ids      Collection of genre identities
  # @option params [String]         :publish_date   Date when book was published(year or exact date)
  # @option params [String]         :search         Search pattern(part of the name)
  # @option params [String]         :isbn           The International Standard Book Number (ISBN)
  # @option params [String]         :sort           Sort type(attribute and sort direction)
end
