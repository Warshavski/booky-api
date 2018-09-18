require 'rails_helper'

RSpec.describe Publisher, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should { have_many(:books) } }

    it { should { have_many(:books_in_shops).class_name('Book').source(:books) } }

    it { should { have_many(:shops_with_books).through(:books_in_stock).source(:shops) } }
  end

  describe '.search' do
    let(:publisher) { create(:publisher, name: 'wat publisher') }

    it 'returns publisher with a matching name' do
      expect(described_class.search(publisher.name)).to eq([publisher])
    end

    it 'returns publisher with a partially matching name' do
      expect(described_class.search(publisher.name[0..2])).to eq([publisher])
    end

    it 'returns publisher with a matching name regardless of the casing' do
      expect(described_class.search(publisher.name.upcase)).to eq([publisher])
    end
  end
end
