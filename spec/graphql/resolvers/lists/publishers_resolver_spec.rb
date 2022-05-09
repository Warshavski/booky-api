require 'rails_helper'

RSpec.describe Resolvers::Lists::PublishersResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let(:params) { { search: 'wat', sort: '-title,id' } }

    shared_examples 'publishers query call' do
      it 'is expected to call publishers query with given params' do
        publishers = build_pair(:publisher)

        expect(PublishersQuery).to(
          receive(:call).with(params: params).and_return(publishers)
        )

        is_expected.to eq(publishers)
      end
    end

    it_behaves_like 'publishers query call'

    context 'when params are empty' do
      let(:params) { {} }

      it_behaves_like 'publishers query call'
    end
  end
end
