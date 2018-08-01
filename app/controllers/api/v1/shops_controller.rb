module Api
  module V1
    # Api::V1::ShopsController
    #
    #   Used to manage shops
    #
    #     - retrieve information about shops
    #
    class ShopsController < ApplicationController

      # GET : api/v1/publishers/{:publisher_id}/shops
      #
      # Get a list of shops selling at least one book of given publisher
      #
      def index
        shops = ShopsComposer.new.compose(Publisher.find(params[:publisher_id]))

        render json: { shops: shops }, status: :ok
      end

    end
  end
end