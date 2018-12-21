# frozen_string_literal: true

# ShopsComposer
#
#   Used to represent shops with information about books
#
class ShopsComposer

  # Compose shops where publisher books in sale
  #
  # @param [Publisher] publisher
  #   The publisher, whose books are on sale at shops
  #
  # @return [Hash]
  #
  # @option [String]      :id               - shop identity
  # @option [String]      :name             - shop name
  # @option [String]      :books_sold_count - number of books sold by this shop
  # @option [Array<Hash>] :books_in_stock   - book collection in the shop stock
  #
  # Example :
  #
  # ShopsComposer.compose(publisher)
  #
  # {
  #   "id": 1,
  #   "name": "wat shop name",
  #   "books_sold_count": 7,
  #   "books_in_stock": [
  #     {
  #       "id": 1,
  #       "title": "wat book",
  #       "copies_in_stock": 10
  #     },
  #   ]
  # }
  #
  def compose(publisher)
    shops_with_books = find_shops(publisher).to_a
    books_grouped_by_shop = find_books(publisher).group_by(&:shop_id)

    shops_with_books.map do |shop|
      books = books_grouped_by_shop[shop.id] || []
      shop.attributes.merge!('books_in_stock' => truncate_books_attrs(books))
    end
  end

  private

  def find_shops(publisher)
    publisher.shops_with_books
             .select(:id, :name)
             .joins('LEFT OUTER JOIN sales ON sales.shop_id = shops.id and books.id = sales.book_id')
             .select('sum(sales.quantity) as books_sold_count')
             .group('shops.id')
  end

  def find_books(publisher)
    publisher.books_in_stock.select(
      'books.id, books.title, stocks.shop_id, stocks.quantity as copies_in_stock'
    )
  end

  def truncate_books_attrs(books)
    books.map { |b| b.attributes.without('shop_id') }
  end
end
