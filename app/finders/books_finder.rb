# frozen_string_literal: true

# BooksFinder
#
#   Used to search, filter, and sort the collection of books
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class BooksFinder
  include PaginationFilters

  attr_reader :params

  # @param [Hash] params (optional, default: {}) filter and sort parameters
  #
  # @option params [Integer]        :publisher_id   Publisher identity
  # @option params [Integer]        :author_id      Book author identity
  # @option params [Array<Integer>] :genre_ids      Collection of genre identities
  # @option params [String]         :publish_date   Date when book was published(year or exact date)
  # @option params [String]         :search         Search pattern(part of the name)
  # @option params [String]         :isbn           The International Standard Book Number (ISBN)
  # @option params [String]         :sort           Sort type(attribute and sort direction)
  # @option params [Integer]        :page           Page number
  # @option params [Integer]        :limit          Quantity of items per page
  #
  def initialize(params = {})
    @params = params
  end

  def execute
    collection = Book

    collection = filter_by_publisher(collection)
    collection = filter_by_author(collection)
    collection = filter_by_genre(collection)

    collection = filter_by_publish_date(collection)

    collection = filter_by_search(collection)
    collection = filter_by_isbn(collection)

    collection = filter_by_limit(collection)
    collection = paginate_items(collection)

    sort(collection)
  end

  private

  def filter_by_publisher(items)
    params[:publisher_id].present? ? items.where(publisher_id: params[:publisher_id]) : items
  end

  def filter_by_author(items)
    return items if params[:author_id].blank?

    items.joins(:authors).merge(Author.where(id: params[:author_id]))
  end

  def filter_by_genre(items)
    return items if params[:genre_ids].blank?

    items.joins(:genres).merge(Genre.where(id: params[:genre_ids])).distinct
  end

  def filter_by_publish_date(items)
    publish_date = params[:publish_date]

    return items if publish_date.blank?

    return items.where(published_at: publish_date) if publish_date.length > 4

    items.where('published_at between ? and ?', "#{publish_date}-01-01", "#{publish_date}-12-31")
  end

  def filter_by_isbn(items)
    if params[:isbn].present?
      items.where(isbn_10: params[:isbn])
           .or(items.where(isbn_13: params[:isbn]))
    else
      items
    end
  end

  def filter_by_search(items)
    params[:search].present? ? items.search(params[:search]) : items
  end

  def sort(items)
    params[:sort].present? ? items.order_by(params[:sort]) : items.order_by(:created_asc)
  end
end
