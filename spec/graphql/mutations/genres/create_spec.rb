# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Genres::Create do
  subject(:mutation) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { mutation.resolve(attributes: params) }

    let(:params) { { name: 'name', description: 'desc' } }

    context 'when interactor succeed' do
      it 'is expected to return success result with genre model' do
        genre_stub = build(:genre)
        result_stub = double('result', success?: true, object: genre_stub)

        expect(Genres::Create).to(
          receive(:call).with({ params: params }).and_return(result_stub)
        )

        expected_result = { genre: genre_stub, errors: [] }
        is_expected.to eq(expected_result)
      end
    end

    context 'when interactor fails' do
      it 'is expected to return fail result with errors' do
        errors_stub = [{ code: 400, path: %i[parameter name], message: 'not valid' }]
        result_stub = double('result', success?: false, errors: errors_stub)

        expect(Genres::Create).to(
          receive(:call).with({ params: params }).and_return(result_stub)
        )

        expected_result = { genre: nil, errors: errors_stub }
        is_expected.to eq(expected_result)
      end
    end
  end
end
