# frozen_string_literal: true

module Api
  module V1
    # Api::V1::SalesController
    #
    #   Used to manage sales in specific shop
    #
    #     - create a new sale
    #
    class SalesController < ApplicationController

      # POST : api/v1/shops/{:shop_id}/sales
      #
      # Create a sale of the book
      #
      def create
        sale = SaleCommand.new(Shop.find(params[:shop_id])).execute(sale_params)

        render json: { sale: sale }, status: :created
      end

      private

      def sale_params
        params.require(:sale).permit(:book_id, :quantity)
      end

    end
  end
end
