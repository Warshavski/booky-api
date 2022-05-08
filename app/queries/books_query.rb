# frozen_string_literal: true

# BooksFinder
#
#   Used to search, filter, and sort the collection of books
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class BooksQuery < ApplicationQuery
  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [Integer]        :publisher_id   Publisher identity
  # @option params [Integer]        :author_id      Book author identity
  # @option params [Array<Integer>] :genre_ids      Collection of genre identities
  # @option params [String]         :publish_date   Date when book was published(year or exact date)
  # @option params [String]         :search         Search pattern(part of the name)
  # @option params [String]         :isbn           The International Standard Book Number (ISBN)
  # @option params [String]         :sort           Sort type(attribute and sort direction)
  #
  def initialize(context:, params: {})
    super(context: context || Book.all, params: params)
  end

  def execute
    search(context)
      .then(&method(:filter_by_publisher))
      .then(&method(:filter_by_author))
      .then(&method(:filter_by_genre))
      .then(&method(:filter_by_publish_date))
      .then(&method(:filter_by_isbn))
      .then(&method(:sort))
  end

  private

  def search(items)
    return items if filter_params[:search].blank?

    items.fuzzy_search(filter_params[:search], %i[title])
  end

  def filter_by_publisher(items)
    return items if filter_params[:publisher_id].blank?

    items.where(publisher_id: filter_params[:publisher_id])
  end

  def filter_by_author(items)
    return items if filter_params[:author_id].blank?

    items.joins(:authors).merge(Author.where(id: filter_params[:author_id]))
  end

  def filter_by_genre(items)
    return items if filter_params[:genre_ids].blank?

    items.joins(:genres).merge(Genre.where(id: filter_params[:genre_ids])).distinct
  end

  def filter_by_publish_date(items)
    return items if filter_params[:publish_date].blank?

    publish_date = ApplicationRecord.sanitize_sql_like(filter_params[:publish_date].to_s)

    if publish_date.length > 4
      items.where(published_at: publish_date)
    else
      # looks legit
      items.where('published_at between ? and ?', "#{publish_date}-01-01", "#{publish_date}-12-31")
    end
  end

  def filter_by_isbn(items)
    return items if filter_params[:isbn].blank?

    items.where(isbn10: filter_params[:isbn])
         .or(items.where(isbn13: filter_params[:isbn]))
  end
end
