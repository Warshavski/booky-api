require 'rails_helper'

RSpec.describe AuthorsFinder do

  describe '#execute' do
    let!(:authors) { create_list(:author_seq, 10) }

    context 'sort only' do
      it 'sorts by recently_created' do
        authors_finder = described_class.new(sort: 'created_asc')
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v1')
      end

      it 'sorts by last_created' do
        authors_finder = described_class.new(sort: 'created_desc')
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v10')
      end

      it 'sorts by first_name ascending' do
        authors_finder = described_class.new(sort: 'first_name_asc')
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v1')
      end

      it 'sorts by first_name descending' do
        authors_finder = described_class.new(sort: 'first_name_desc')
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v9')
      end

      it 'sorts by last_name ascending' do
        authors_finder = described_class.new(sort: 'last_name_asc')
        result = authors_finder.execute

        expect(result.first.last_name).to eq('ln-v1')
      end

      it 'sorts by last_name descending' do
        authors_finder = described_class.new(sort: 'last_name_desc')
        result = authors_finder.execute

        expect(result.first.last_name).to eq('ln-v9')
      end
    end

    context 'filter only' do
      it 'filters authors by first_name' do
        authors_finder = described_class.new(search: 'fn-v7')
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v7')
        expect(result.count).to be(1)
      end

      it 'filters authors by last_name' do
        authors_finder = described_class.new(search: 'ln-v7')
        result = authors_finder.execute

        expect(result.first.last_name).to eq('ln-v7')
        expect(result.count).to be(1)
      end

      it 'does not find any author with given search parameter' do
        authors_finder = described_class.new(search: 'wat-name?')
        result = authors_finder.execute

        expect(result.count).to be(0)
      end

      it 'filters authors by book' do
        book = create(:book, authors: authors[0..1])

        authors_finder = described_class.new(book_id: book.id)
        result = authors_finder.execute

        expect(result.first.first_name).to eq('fn-v1')
        expect(result.count).to be(2)
      end

      it 'filters authors by book and last_name' do
        book = create(:book, authors: authors[0..1])

        authors_finder = described_class.new(book_id: book.id, search: authors[1].last_name)
        result = authors_finder.execute

        expect(result.first.last_name).to eq('ln-v2')
        expect(result.count).to be(1)
      end

      it 'filters authors by page' do
        allow(Booky.config.pagination).to receive(:limit).and_return(5)

        authors_finder = described_class.new(page: 2)
        result = authors_finder.execute

        expect(result.count).to be(5)
        expect(result.first.first_name).to eq('fn-v6')
      end

      it 'filters authors by page and limit' do
        authors_finder = described_class.new(page: 1, limit: 5)
        result = authors_finder.execute

        expect(result.count).to be(5)
        expect(result.last.first_name).to eq('fn-v5')
      end

      it 'does not finds any author by page of range' do
        authors_finder = described_class.new(page: 100)
        result = authors_finder.execute

        expect(result.count).to be(0)
      end

      it 'does not returns any author by zero limit' do
        authors_finder = described_class.new(limit: 0)
        result = authors_finder.execute

        expect(result.count).to be(0)
      end
    end

    context 'filter and sort' do
      it 'filters authors by last_name and sorts by recently_created' do
        authors_finder = described_class.new(sort: 'created_desc', search: 'ln-v')
        result = authors_finder.execute

        expect(result.last.last_name).to eq('ln-v1')
        expect(result.count).to eq(10)
      end

      it 'filters authors by last_name and sorts by last_created' do
        authors_finder = described_class.new(sort: 'created_asc', search: 'ln-v')
        result = authors_finder.execute

        expect(result.last.last_name).to eq('ln-v10')
        expect(result.count).to eq(10)
      end

      it 'filters authors by first_name and sorts by last_name descending' do
        authors_finder = described_class.new(sort: 'last_name_desc', search: 'fn-v')
        result = authors_finder.execute

        expect(result.first.last_name).to eq('ln-v9')
        expect(result.count).to eq(10)
      end

      it 'filters authors by book and sorts by first_name' do
        book = create(:book, authors: authors[0..2])

        authors_finder = described_class.new(sort: 'first_name_asc', book_id: book.id)
        result = authors_finder.execute

        expect(result.last.first_name).to eq('fn-v3')
        expect(result.count).to eq(3)
      end

      it 'filters authors by page and limit and sorts by first_name descending' do
        authors_finder = described_class.new(sort: 'first_name_desc', page: 2, limit: 5)
        result = authors_finder.execute

        expect(result.last.first_name).to eq('fn-v1')
        expect(result.count).to eq(5)
      end
    end
  end
end
