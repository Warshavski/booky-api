require 'rails_helper'

RSpec.describe Resolvers::Lists::AuthorsResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let(:params) { { search: 'wat', sort: '-title,id', book_id: 1 } }

    shared_examples 'authors query call' do
      it 'is expected to call authors query with given params' do
        authors = build_pair(:author)

        expect(AuthorsQuery).to(
          receive(:call).with(params: params).and_return(authors)
        )

        is_expected.to eq(authors)
      end
    end

    it_behaves_like 'authors query call'

    context 'when params are empty' do
      let(:params) { {} }

      it_behaves_like 'authors query call'
    end
  end
end
