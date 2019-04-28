# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::PublishersController
      #
      #   Used to manage books publishers(CRUD)
      #
      class PublishersController < ApplicationController

        set_default_serializer PublisherSerializer

        # GET : api/v1/admin/publishers
        #
        #   optional query parameters :
        #
        #     - standard filters (@see filter_params)
        #
        # Get a list of publishers
        #
        def index
          publishers = filter_publishers(filter_params)

          render_resource publishers, is_collection: true, status: :ok
        end

        # GET : api/v1/admin/publishers/{:id}
        #
        # Get a specific publisher identified by id
        #
        def show
          publisher = filter_publishers.find_by(id: params[:id])

          process_record(publisher) do |p|
            render_resource p, status: :ok
          end
        end

        # POST : api/v1/admin/publishers
        #
        # Create a new publisher
        #
        def create
          publisher = Publisher.create!(publishers_params)

          render_resource publisher, status: :created
        end

        # PATCH/PUT : api/v1/admin/publishers/{:id}
        #
        # Update information about publisher
        #
        def update
          publisher = filter_publishers.find_by(id: params[:id])

          process_record(publisher) do |p|
            p.update!(publishers_params)

            head :no_content
          end
        end

        # DELETE : api/v1/admin/publishers/{:id}
        #
        # Delete publisher from storage
        #
        def destroy
          publisher = filter_publishers.find_by(id: params[:id])

          process_record(publisher) do |p|
            p.destroy!

            head :no_content
          end
        end

        private

        def filter_publishers(filters = {})
          PublishersFinder.new(filters).execute
        end

        def publishers_params
          restify_param(:publisher)
            .require(:publisher)
            .permit(:name, :description, :email, :phone, :address, :postcode)
        end
      end
    end
  end
end
