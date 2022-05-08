require 'rails_helper'

RSpec.describe Resolvers::BooksResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let(:params) do
      {
        search: 'wat',
        sort: '-title,id',
        publisher_id: 1,
        author_id: 2,
        genre_ids: [3, 4],
        publish_date: '2019',
        isbn: '1234567890'
      }
    end

    shared_examples 'books query call' do
      it 'is expected to call books query with given params' do
        books = build_pair(:book)

        expect(BooksQuery).to(
          receive(:call).with(params: params).and_return(books)
        )

        is_expected.to eq(books)
      end
    end

    it_behaves_like 'books query call'

    context 'when params are empty' do
      let(:params) { {} }

      it_behaves_like 'books query call'
    end
  end
end
