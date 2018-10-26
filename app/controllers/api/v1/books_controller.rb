module Api
  module V1
    # Api::V1::BooksController
    #
    #   Used to manage books (CRUD)
    #
    class BooksController < ApplicationController

      set_default_serializer Books::CoreSerializer

      # GET : api/v1/books
      #
      #   optional query parameters :
      #
      #     - standard filters (@see filter_params)
      #
      #     - isbn          filter by The International Standard Book Number (ISBN)
      #                       example: ?isbn=1234567890
      #
      #     - publisher_id  filter by publisher
      #                       example: ?publisher_id=1
      #
      #     - publish_date  filter by publish date(filter by year or by specific date)
      #                       example: ?publish_date=2018  |  ?publish_date=2018-10-29
      #
      #     - genre_ids     filter by genres
      #                       example: ?genre_ids[]=1&genre_ids[]=2
      #
      # Get a list of the books (books preview)
      #
      def index
        books = filter_books(filter_params)

        render_json books, is_collection: true, status: :ok
      end

      # GET : api/v1/books/{:id}
      #
      # Get a specific book identified by id (detailed info)
      #
      def show
        book = filter_books
                 .preload(:authors, :genres)
                 .find_by(id: params[:id])

        process_record(book) do |book_record|
          render_json book_record,
                      serializer: Books::DetailedSerializer,
                      include: %i[authors genres],
                      status: :ok
        end
      end

      # POST : api/v1/books
      #
      # Create a new book
      #
      def create
        book = Book.create!(books_params)

        render_json book, status: :created
      end

      # PATCH/PUT : api/v1/books/{:id}
      #
      # Update information about book
      #
      def update
        book = filter_books.find_by(id: params[:id])

        process_record(book) do |book_record|
          book_record.update!(books_params)

          head :no_content
        end
      end

      # DELETE : api/v1/books/{:id}
      #
      # Delete book from storage
      #
      def destroy
        book = filter_books.find_by(id: params[:id])

        process_record(book) do |book_record|
          book_record.destroy!

          head :no_content
        end
      end

      private

      def filter_books(filters = {})
        BooksFinder.new(filters).execute
      end

      def specific_filters
        [:isbn, :publisher_id, :publish_date, genre_ids: []]
      end

      def books_params
        params
          .require(:book)
          .permit(:title, :description, :published_at, :isbn_10, :isbn_13, :publisher_id, :weight, :pages_count)
      end
    end
  end
end
