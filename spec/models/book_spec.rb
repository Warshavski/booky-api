require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }

    it { should validate_presence_of(:publisher) }
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
