require 'rails_helper'

RSpec.describe BooksQuery do
  describe '.call' do
    subject { described_class.call(params: params) }

    let_it_be(:book)                  { create(:book, :with_genres) }
    let_it_be(:book_with_author)      { create(:book, :with_authors, published_at: '2000-12-23') }
    let_it_be(:expected_search_book)  { create(:book, :with_genres, title: 'wat') }

    let(:params) { {} }

    it 'is expected to return all books' do
      expected_books = [
        expected_search_book,
        book_with_author,
        book
      ]

      is_expected.to eq(expected_books)
    end

    context 'when publisher_id is set' do
      let(:params) { { publisher_id: book.publisher_id } }

      it { is_expected.to eq([book]) }
    end

    context 'when author_id is set' do
      let(:params) { { author_id: book_with_author.authors[0].id } }

      it { is_expected.to eq([book_with_author]) }
    end

    context 'when genre_ids is set' do
      let(:params) do
        { genre_ids: [book.genres[0].id, expected_search_book.genres[0].id] }
      end

      it { is_expected.to eq([expected_search_book, book]) }
    end

    context 'when isbn13 is set' do
      let(:params) { { isbn: book.isbn13 } }

      it { is_expected.to eq([book]) }
    end

    context 'when isbn10 is set' do
      let(:params) { { isbn: expected_search_book.isbn10 } }

      it { is_expected.to eq([expected_search_book]) }
    end

    context 'when exact publish date is set' do
      let(:params) { { publish_date: book_with_author.published_at } }

      it { is_expected.to eq([book_with_author]) }
    end

    context 'when publish year is set' do
      let(:params) { { publish_date: book_with_author.published_at.year } }

      it { is_expected.to eq([book_with_author]) }
    end

    context 'when search param is equal to title' do
      let(:params) { { search: expected_search_book.title } }

      it { is_expected.to eq([expected_search_book]) }
    end

    context 'when search param is equal to partially matching title' do
      let(:params) { { search: expected_search_book.title[0..2] } }

      it { is_expected.to eq([expected_search_book]) }
    end

    context 'when search param is equal to title regardless of the casing' do
      let(:params) { { search: expected_search_book.title.upcase } }

      it { is_expected.to eq([expected_search_book]) }
    end
  end
end
