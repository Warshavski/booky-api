# frozen_string_literal: true

# SaleCommand
#
#   User to create a new sale
#
class SaleCommand

  attr_reader :current_shop

  # @param [Shop] shop
  #   shop where the sale takes place
  #
  def initialize(shop)
    @current_shop = shop
  end

  # Execute sale in shop
  #
  # @param [Hash] params parameters of sale(book and number of copies)
  #
  # @option :params [Integer] book_id
  # @option :params [Integer] quantity
  #
  # @return [Sale]
  #
  def execute(params)
    stock = current_shop.stocks.find_by(book_id: params[:book_id])

    raise ActiveRecord::RecordNotFound, 'Stock not found' if stock.nil?

    Sale.transaction do
      stock.update!(quantity: stock.quantity - params[:quantity].to_i)
      current_shop.sales.create!(params)
    end
  end
end
