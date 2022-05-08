require 'rails_helper'

RSpec.describe Resolvers::GenreResolver do
  subject(:resolver) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { resolver.resolve(**params) }

    let_it_be(:genre) { create(:genre) }

    let(:params) { { id: genre.id } }

    it { is_expected.to eq(genre) }

    context 'when id does not set' do
      let(:params) { {} }

      it { expect { subject }.to raise_error(ArgumentError, 'missing keyword: :id') }
    end

    context 'when genre does not exist' do
      let(:params) { { id: 0 } }

      it 'is expected to raise not found error' do
        expect { subject }.to(
          raise_error(
            ActiveRecord::RecordNotFound,
            "Couldn't find Genre with 'id'=#{params[:id]}"
          )
        )
      end
    end
  end
end
