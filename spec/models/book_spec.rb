require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    subject { create(:book) }

    it { should validate_presence_of(:title) }

    it { should validate_presence_of(:publisher) }

    it { should validate_presence_of(:published_at) }

    it { should validate_length_of(:isbn_10).is_equal_to(10) }

    it { should validate_length_of(:isbn_13).is_equal_to(13) }

    it { should validate_uniqueness_of(:isbn_10).case_insensitive.allow_nil }

    it { should validate_uniqueness_of(:isbn_13).case_insensitive.allow_nil }
  end

  describe 'associations' do
    it { should { belong_to(:publisher) } }

    it { should { have_many(:stocks) } }

    it { should { have_many(:shops).through(:stocks) } }

    it { should { have_many(:sales) } }
  end

  describe '.in_stock' do
    let!(:stock_non_zero_qnt) { create(:stock) }
    let!(:stock_zero_qnt) { create(:stock, quantity: 0) }

    it 'returns only in stock' do
      expect(described_class.in_stock).to eq([stock_non_zero_qnt.book])
    end
  end
end
