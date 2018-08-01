require 'rails_helper'

describe ShopsComposer do
  subject { described_class.new }

  describe '.compose' do
    let!(:publisher_without_books) { create(:publisher) }
    let!(:publisher_with_books) { create(:publisher_with_books, books_count: 2) }

    let(:shop)  { create(:shop) }
    let(:books) { publisher_with_books.books }

    let!(:stocks) { books.map { |b| create(:stock, shop: shop, book: b) } }

    it 'returns empty array' do
      expect(subject.compose(publisher_without_books)).to eq([])
    end

    context 'shops with books in stock' do
      it 'returns correct shops count' do
        expect(subject.compose(publisher_with_books).size).to eq(1)
      end

      it 'returns correct shops format' do
        shop_entity = subject.compose(publisher_with_books).first

        expect(shop_entity.keys).to match_array(%w[id name books_sold_count books_in_stock])
      end

      it 'returns correct books_in_stock count' do
        shop_entity = subject.compose(publisher_with_books).first

        expect(shop_entity['books_in_stock'].size).to be(2)
      end

      it 'returns correct books_in_stock format' do
        shop_entity = subject.compose(publisher_with_books).first

        expect(shop_entity['books_in_stock'].first.keys).to match_array(%w[id title copies_in_stock])
      end
    end

    context 'shops with sales' do
      let!(:sale) { create(:sale, shop: shop, book: books.first) }

      it 'returns shop with sale information' do
        shop_entity = subject.compose(publisher_with_books).first

        expect(shop_entity['books_sold_count']).to be(1)
      end
    end

  end
end
