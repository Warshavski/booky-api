module Api
  module V1
    # Api::V1::PublishersController
    #
    #   Used to manage books publishers(CRUD)
    #
    class PublishersController < ApplicationController

      # GET : api/v1/publishers
      #
      # Get a list of publishers
      #
      def index
        publishers = filter_publishers(filter_params)

        render json: { data: publishers }, status: :ok
      end

      # GET : api/v1/publishers/{:id}
      #
      # Get a specific publisher identified by id
      #
      def show
        publisher = filter_publishers.find_by(id: params[:id])

        execute_action(publisher) do |p|
          render json: { data: p }, status: :ok
        end
      end

      # POST : api/v1/publishers
      #
      # Create a new publisher
      #
      def create
        publisher = Publisher.create!(publishers_params)

        render json: { data: publisher }, status: :created
      end

      # PATCH/PUT : api/v1/publishers/{:id}
      #
      # Update information about publisher
      #
      def update
        publisher = filter_publishers.find_by(id: params[:id])

        execute_action(publisher) do |p|
          p.update!(publishers_params)

          head :no_content
        end
      end

      # DELETE : api/v1/publishers/{:id}
      #
      # Delete publisher from storage
      #
      def destroy
        publisher = filter_publishers.find_by(id: params[:id])

        execute_action(publisher) do |p|
          p.destroy!

          head :no_content
        end
      end

      private

      def filter_publishers(filters = {})
        PublishersFinder.new(filters).execute
      end

      def filter_params
        params.permit(:search, :sort)
      end

      def publishers_params
        params.require(:publisher).permit(:name, :description, :email, :phone, :address, :postcode)
      end

      def execute_action(publisher)
        if publisher.nil?
          render_not_found
        else
          yield(publisher)
        end
      end

      def render_not_found
        render json: { error: 'Publisher not found' }, status: :not_found
      end
    end
  end
end
