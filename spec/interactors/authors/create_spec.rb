require 'rails_helper'

RSpec.describe Authors::Create do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        first_name: 'first_name',
        last_name: 'last_name',
        biography: "Very long author's bio...",
        born_in: '2012-02-02',
        died_in: '2015-02-02',
        book_ids: book_ids
      }
    end

    let(:book_ids) { [] }

    it 'is expected to create a new author' do
      expect { subject }.to change(Author, :count).by(1)

      expect(subject.success?).to be(true)

      expected_author = Author.order(id: :desc).first
      actual_author = subject.object
      expect(actual_author).to eq(expected_author)

      expect(actual_author.first_name).to eq(params[:first_name])
      expect(actual_author.last_name).to eq(params[:last_name])
      expect(actual_author.biography).to eq(params[:biography])
      expect(actual_author.born_in.to_s).to eq(params[:born_in])
      expect(actual_author.died_in.to_s).to eq(params[:died_in])
    end

    context 'when book_ids are set' do
      let(:book_ids)  { books.map { |b| b.id.to_s } }
      let(:books)     { create_list(:book, 2) }

      it 'is expected to set author-books relations' do
        expect { subject }.to change(Author, :count).by(1)

        expect(subject.success?).to be(true)

        actual_author = subject.object
        expect(actual_author.books).to match_array(books)
      end
    end

    context 'when not existing book_ids are set' do
      let(:book_ids)  { %w[0 1] }

      it 'is expected to raise not found error' do
        msg = "Couldn't find all Books with 'id': (0, 1) " \
              "(found 0 results, but was looking for 2). " \
              "Couldn't find Books with ids 0, 1."

        expect { subject }.to raise_error(ActiveRecord::RecordNotFound, msg)
      end
    end

    context 'when author params are invalid' do
      let(:params) do
        {
          last_name: nil,
          biography: 123,
          born_in: '',
          died_in: 'date',
        }
      end

      it 'is expected to fail with error' do
        is_expected.to be_failure

        expected_errors = [
          { code: 400, path: %i[parameter first_name], message: 'is missing' },
          { code: 400, path: %i[parameter last_name], message: 'must be filled' },
          { code: 400, path: %i[parameter biography], message: 'must be a string' },
          { code: 400, path: %i[parameter born_in], message: 'must be filled' },
          { code: 400, path: %i[parameter died_in], message: 'must be a date' }
        ]

        expect(subject.errors).to match_array(expected_errors)
      end
    end
  end
end
