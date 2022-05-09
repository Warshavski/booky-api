require 'rails_helper'

RSpec.describe Resolvers::AuthorResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let_it_be(:author) { create(:author) }

    let(:params) { { id: author.id } }

    it { is_expected.to eq(author) }

    context 'when id does not set' do
      let(:params) { {} }

      it { expect { subject }.to raise_error(ArgumentError, 'missing keyword: :id') }
    end

    context 'when author does not exist' do
      let(:params) { { id: 0 } }

      it 'is expected to raise not found error' do
        expect { subject }.to(
          raise_error(
            ActiveRecord::RecordNotFound,
            "Couldn't find Author with 'id'=#{params[:id]}"
          )
        )
      end
    end
  end
end
