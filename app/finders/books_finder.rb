# frozen_string_literal: true

# BooksFinder
#
#   Used to search, filter, and sort the collection of books
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class BooksFinder < BaseFinder
  filter(:publisher_id) do |items, params|
    params[:publisher_id].present? ? items.where(publisher_id: params[:publisher_id]) : items
  end

  filter(:author_id) do |items, params|
    if params[:author_id].present?
      items.joins(:authors).merge(Author.where(id: params[:author_id]))
    else
      items
    end
  end

  filter(:genre_ids) do |items, params|
    if params[:genre_ids].present?
      items.joins(:genres).merge(Genre.where(id: params[:genre_ids])).distinct
    else
      items
    end
  end

  filter(:publish_date) do |items, params|
    publish_date = params[:publish_date]

    if publish_date.blank?
      items
    elsif publish_date.length > 4
      items.where(published_at: publish_date)
    else
      items.where('published_at between ? and ?', "#{publish_date}-01-01", "#{publish_date}-12-31")
    end
  end

  filter(:isbn) do |items, params|
    if params[:isbn].present?
      items.where(isbn_10: params[:isbn])
           .or(items.where(isbn_13: params[:isbn]))
    else
      items
    end
  end

  filter(:search) do |items, params|
    params[:search].present? ? items.search(params[:search]) : items
  end

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
  def initialize(params = {})
    super
    @collection = Book
  end
end
