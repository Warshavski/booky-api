require 'rails_helper'

RSpec.describe BooksFinder do

  describe '#execute' do
    let(:publisher) { create(:publisher) }

    let!(:books) { create_list(:book_seq, 10, publisher: publisher) }

    context 'sort only' do
      it 'sorts by recently_created' do
        books_finder = described_class.new(sort: 'created_asc')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
      end

      it 'sorts by last_created' do
        books_finder = described_class.new(sort: 'created_desc')
        result = books_finder.execute

        expect(result.first.title).to eq('v10')
      end

      it 'sorts by title ascending' do
        books_finder = described_class.new(sort: 'title_asc')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
      end

      it 'sorts by title descending' do
        books_finder = described_class.new(sort: 'title_desc')
        result = books_finder.execute

        expect(result.first.title).to eq('v9')
      end
    end

    context 'filter only' do
      it 'filters books by publisher' do
        books_finder = described_class.new(publisher_id: publisher.id)
        result = books_finder.execute

        expect(result.count).to be(10)
      end

      it 'does not find any book by given publisher' do
        books_finder = described_class.new(publisher_id: 'wat publisher')
        result = books_finder.execute

        expect(result.count).to be(0)
      end

      it 'filters books by title' do
        books_finder = described_class.new(search: 'v7')
        result = books_finder.execute

        expect(result.first.title).to eq('v7')
        expect(result.count).to be(1)
      end

      it 'does not find any books with given title' do
        books_finder = described_class.new(search: 'wat title')
        result = books_finder.execute

        expect(result.count).to be(0)
      end

      it 'filters books by search and publisher' do
        books_finder = described_class.new(search: 'v7', publisher_id: publisher.id)
        result = books_finder.execute

        expect(result.first.title).to eq('v7')
        expect(result.count).to be(1)
      end

      it 'filters books by exact publish date' do
        books.first.update!(published_at: '2018-10-06')

        books_finder = described_class.new(publish_date: '2018-10-06')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
        expect(result.count).to be(1)
      end

      it 'filters books by publish year' do
        books.first.update!(published_at: '2000-10-06')
        books.last.update!(published_at: '2000-12-24')

        books_finder = described_class.new(publish_date: '2000')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
        expect(result.count).to be(2)
      end

      it 'filters books by isbn' do
        books.first.update!(isbn_13: '1234567890123')
        books.first.update!(isbn_10: '0987654321')

        books_finder = described_class.new(isbn: '0987654321')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
        expect(result.count).to be(1)
      end

      it 'filters books by author' do
        author = create(:author)
        books[0..4].each { |b| b.update!(authors: [author]) }

        books_finder = described_class.new(author_id: author.id)
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
        expect(result.count).to be(5)
      end

      it 'filters books by author and book title' do
        author = create(:author)
        books[0..4].each { |b| b.update!(authors: [author]) }

        books_finder = described_class.new(author_id: author.id, search: 'v3')
        result = books_finder.execute

        expect(result.first.title).to eq('v3')
        expect(result.count).to be(1)
      end

      it 'does not finds any book by given author' do
        author = create(:author)

        books_finder = described_class.new(author_id: author.id)
        result = books_finder.execute

        expect(result.count).to be(0)
      end

      it 'does not finds any book by existed author and not existed book' do
        author = create(:author)
        books.sample.update!(authors: [author])

        books_finder = described_class.new(author_id: author.id, search: 'wat_book')
        result = books_finder.execute

        expect(result.count).to be(0)
      end

      it 'does not finds any book by not existed author' do
        books_finder = described_class.new(author_id: 'wat_author?')
        result = books_finder.execute

        expect(result.count).to be(0)
      end
    end

    context 'filter and sort' do
      it 'filters books by title and sorts by recently_created' do
        books_finder = described_class.new(sort: 'created_desc', search: 'v')
        result = books_finder.execute

        expect(result.last.title).to eq('v1')
        expect(result.count).to eq(10)
      end

      it 'filters books by title and sorts by last_created' do
        books_finder = described_class.new(sort: 'created_asc', search: 'v')
        result = books_finder.execute

        expect(result.last.title).to eq('v10')
        expect(result.count).to eq(10)
      end

      it 'filters books by title and sorts by title descending' do
        books_finder = described_class.new(sort: 'title_desc', search: 'v')
        result = books_finder.execute

        expect(result.first.title).to eq('v9')
        expect(result.count).to eq(10)
      end

      it 'filters books by title and sorts by title ascending' do
        books_finder = described_class.new(sort: 'title_asc', search: 'v')
        result = books_finder.execute

        expect(result.first.title).to eq('v1')
        expect(result.count).to eq(10)
      end

      it 'filters books by publish year and sort by title desc' do
        books.first.update!(published_at: '2000-10-06')
        books.last.update!(published_at: '2000-12-24')

        books_finder = described_class.new(publish_date: '2000', sort: 'title_desc')
        result = books_finder.execute

        expect(result.first.title).to eq('v10')
        expect(result.count).to be(2)
      end

      it 'filters books by author and sort by title desc' do
        author = create(:author)
        books[0..4].each { |b| b.update!(authors: [author]) }

        books_finder = described_class.new(author_id: author.id, sort: 'title_desc')
        result = books_finder.execute

        expect(result.first.title).to eq('v5')
        expect(result.count).to be(5)
      end
    end
  end
end
