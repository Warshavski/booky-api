module Api
  module V1
    # Api::V1::BooksController
    #
    #   Used to manage books (CRUD)
    #
    class BooksController < ApplicationController

      # GET : api/v1/books
      #
      # Get a list of the books
      #
      def index
        books = filter_books(filter_params)

        render json: { data: books }, status: :ok
      end

      # GET : api/v1/books/{:id}
      #
      # Get a specific book identified by id (detailed info)
      #
      def show
        book = filter_books.find_by(id: params[:id])

        execute_action(book) do |b|
          render json: { data: b }, status: :ok
        end
      end

      # POST : api/v1/books
      #
      # Create a new book
      #
      def create
        book = Book.create!(books_params)

        render json: { data: book }, status: :created
      end

      # PATCH/PUT : api/v1/books/{:id}
      #
      # Update information about book
      #
      def update
        book = filter_books.find_by(id: params[:id])

        execute_action(book) do |p|
          p.update!(books_params)

          head :no_content
        end
      end

      # DELETE : api/v1/books/{:id}
      #
      # Delete book from storage
      #
      def destroy
        book = filter_books.find_by(id: params[:id])

        execute_action(book) do |p|
          p.destroy!

          head :no_content
        end
      end

      private

      def filter_books(filters = {})
        BooksFinder.new(filters).execute
      end

      def filter_params
        params.permit(:search, :sort, :isbn, :publisher_id, :publish_date, genre_ids: [])
      end

      def books_params
        params
          .require(:book)
          .permit(:title, :description, :published_at, :isbn_10, :isbn_13, :publisher_id, :weight, :pages_count)
      end

      def execute_action(book)
        if book.nil?
          render_not_found
        else
          yield(book)
        end
      end

      def render_not_found
        render json: { error: 'Book not found' }, status: :not_found
      end
    end
  end
end
