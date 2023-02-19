# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:publisher) }

    it { is_expected.to have_many(:books_authors).dependent(:destroy) }
    it { is_expected.to have_many(:authors).through(:books_authors) }

    it { is_expected.to have_many(:books_genres).dependent(:destroy) }
    it { is_expected.to have_many(:genres).through(:books_genres) }
  end

  describe '.by_isbn' do
    subject { described_class.by_isbn(isbn10: isbn10, isbn13: isbn13) }

    let_it_be(:isbn10_book) do
      create(:book, isbn10: '0987654321', isbn13: '1234567890123')
    end

    let_it_be(:isbn13_book) do
      create(:book, isbn10: '1234567890', isbn13: '0987654321123')
    end

    context 'when both params match with books' do
      let(:isbn10) { isbn10_book.isbn10 }
      let(:isbn13) { isbn13_book.isbn13 }

      it { is_expected.to match_array([isbn10_book, isbn13_book]) }
    end

    context 'when only isbn10 match with book' do
      let(:isbn10) { isbn10_book.isbn10 }
      let(:isbn13) { 'wat' }

      it { is_expected.to match_array([isbn10_book]) }
    end

    context 'when only isbn13 match with book' do
      let(:isbn10) { 'wat' }
      let(:isbn13) { isbn13_book.isbn13 }

      it { is_expected.to match_array([isbn13_book]) }
    end
  end
end
