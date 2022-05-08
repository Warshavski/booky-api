require 'rails_helper'

RSpec.describe Resolvers::GenresResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let(:params) { { search: 'wat', sort: '-title,id' } }

    shared_examples 'genres query call' do
      it 'is expected to call genres query with given params' do
        genres = build_pair(:genre)

        expect(GenresQuery).to(
          receive(:call).with(params: params).and_return(genres)
        )

        is_expected.to eq(genres)
      end
    end

    it_behaves_like 'genres query call'

    context 'when params are empty' do
      let(:params) { {} }

      it_behaves_like 'genres query call'
    end
  end
end
