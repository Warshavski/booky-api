require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    subject { build(:book) }

    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_presence_of(:published_at) }

    it { is_expected.to validate_presence_of(:pages_count) }

    it { is_expected.to validate_numericality_of(:pages_count).only_integer.is_greater_than_or_equal_to(1) }

    it { is_expected.to validate_numericality_of(:weight).is_greater_than_or_equal_to(0.0).allow_nil }

    it { is_expected.to validate_length_of(:isbn10).is_equal_to(10) }

    it { is_expected.to validate_length_of(:isbn13).is_equal_to(13) }

    it { is_expected.to validate_uniqueness_of(:isbn10).case_insensitive.allow_nil }

    it { is_expected.to validate_uniqueness_of(:isbn13).case_insensitive.allow_nil }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:publisher) }

    it { is_expected.to have_and_belong_to_many(:authors) }

    it { is_expected.to have_and_belong_to_many(:genres) }
  end

  describe '.search' do
    let_it_be(:book) { create(:book, title: 'wat book') }

    it 'returns book with a matching title' do
      expect(described_class.search(book.title)).to eq([book])
    end

    it 'returns book with a partially matching title' do
      expect(described_class.search(book.title[0..2])).to eq([book])
    end

    it 'returns book with a matching title regardless of the casing' do
      expect(described_class.search(book.title.upcase)).to eq([book])
    end
  end
end
