require 'rails_helper'

describe SaleCommand do
  describe '#execute' do
    let(:shop)  { create(:shop) }
    let(:book)  { create(:book) }

    let!(:stock) { create(:stock, shop: shop, book: book) }

    it 'returns created Sale object' do
      sale_command = described_class.new(shop)

      sale = sale_command.execute(book_id: book.id, quantity: 1)

      expect(sale).to be_kind_of(Sale)
    end

    it 'creates new sale' do
      sale_command = described_class.new(shop)

      expect { sale_command.execute(book_id: book.id, quantity: 1) }.to change(Sale, :count).by(1)
    end

    it 'updates stock quantity' do
      sale_command = described_class.new(shop)

      sale_command.execute(book_id: book.id, quantity: 1)

      expect(stock.reload.quantity).to be(0)
    end

    it 'returns sale with expected quantity' do
      sale_command = described_class.new(shop)

      sale = sale_command.execute(book_id: book.id, quantity: 1)

      expect(sale.quantity).to be(1)
    end

    it 'raises ActiveRecord::RecordNotFound error' do
      sale_command = described_class.new(shop)

      expect {
        sale_command.execute(book_id: 'wat_book_id', quantity: 1)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises ActiveRecord::RecordInvalid  error' do
      sale_command = described_class.new(shop)

      expect {
        sale_command.execute(book_id: book.id, quantity: 1000)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
