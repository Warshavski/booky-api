# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Publishers::Create do
  subject(:mutation) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { mutation.resolve(attributes: params) }

    let(:params) do
      {
        name: 'name',
        email: 'email@wat.com',
        phone: '0987654321',
        postcode: '0987654321',
        address: 'wat address 163',
        description: 'description',
      }
    end

    context 'when interactor succeed' do
      it 'is expected to return success result with publisher model' do
        publisher_stub = build(:publisher)
        result_stub = double('result', success?: true, object: publisher_stub)

        expect(Publishers::Create).to(
          receive(:call).with({ params: params }).and_return(result_stub)
        )

        expected_result = { publisher: publisher_stub, errors: [] }
        is_expected.to eq(expected_result)
      end
    end

    context 'when interactor fails' do
      it 'is expected to return fail result with errors' do
        errors_stub = [{ code: 400, path: %i[parameter name], message: 'not valid' }]
        result_stub = double('result', success?: false, errors: errors_stub)

        expect(Publishers::Create).to(
          receive(:call).with({ params: params }).and_return(result_stub)
        )

        expected_result = { publisher: nil, errors: errors_stub }
        is_expected.to eq(expected_result)
      end
    end
  end
end
