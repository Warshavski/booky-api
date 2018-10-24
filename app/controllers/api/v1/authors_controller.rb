module Api
  module V1
    # Api::V1::AuthorsController
    #
    #   Used to manage books authors(CRUD)
    #
    class AuthorsController < ApplicationController

      # GET : api/v1/authors
      #
      # Get a list of authors
      #
      def index
        authors = filter_authors(filter_params)

        render json: { data: authors }, status: :ok
      end

      # GET : api/v1/authors/{:id}
      #
      # Get a specific author identified by id
      #
      def show
        author = filter_authors.find_by(id: params[:id])

        execute_action(author) do |p|
          render json: { data: p }, status: :ok
        end
      end

      # POST : api/v1/authors
      #
      # Create a new author
      #
      def create
        author = Author.create!(authors_params)

        render json: { data: author }, status: :created
      end

      # PATCH/PUT : api/v1/authors/{:id}
      #
      # Update information about author
      #
      def update
        author = filter_authors.find_by(id: params[:id])

        execute_action(author) do |p|
          p.update!(authors_params)

          head :no_content
        end
      end

      # DELETE : api/v1/authors/{:id}
      #
      # Delete author from storage
      #
      def destroy
        author = filter_authors.find_by(id: params[:id])

        execute_action(author) do |p|
          p.destroy!

          head :no_content
        end
      end

      private

      def filter_authors(filters = {})
        AuthorsFinder.new(filters).execute
      end

      def filter_params
        params.permit(:search, :sort, :book_id)
      end

      def authors_params
        params.require(:author).permit(:last_name, :first_name, :biography, :born_in, :died_id)
      end

      def execute_action(author)
        if author.nil?
          render_not_found
        else
          yield(author)
        end
      end

      def render_not_found
        render json: { error: 'Author not found' }, status: :not_found
      end
    end
  end
end
