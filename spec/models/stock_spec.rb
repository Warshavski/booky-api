require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'validations' do
    subject { create(:stock) }

    it { should validate_presence_of(:book) }

    it { should validate_presence_of(:shop) }

    it { should validate_presence_of(:quantity) }

    it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }

    it { should have_db_column(:quantity) }

    it { should validate_uniqueness_of(:book_id).scoped_to(:shop_id) }
  end

  describe 'associations' do
    it { should belong_to(:book) }

    it { should belong_to(:shop) }
  end

  describe '.in_stock' do
    let!(:in_stock) { create(:stock, quantity: 2) }
    let!(:out_of_stock) { create(:stock, quantity: 0) }

    it 'returns only in stock' do
      expect(described_class.in_stock).to eq([in_stock])
    end
  end
end
