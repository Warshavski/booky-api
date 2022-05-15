# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Authors::Update do
  subject(:mutation) { described_class.new(object: nil, context: context, field: nil) }

  let_it_be(:context) do
    GraphQL::Query::Context.new(query: OpenStruct.new(schema: nil), values: { }, object: nil)
  end

  describe '#resolve' do
    subject { mutation.resolve(id: author_id, attributes: params) }

    let(:params) do
      {
        first_name: 'first_name',
        last_name: 'last_name',
        biography: "Very long author's bio...",
        born_in: '2012-02-02',
        died_in: '2015-02-02',
        book_ids: [1, 3]
      }
    end

    let(:author_id) { 1 }

    context 'when interactor succeed' do
      it 'is expected to return success result with author model' do
        author_stub = build(:author)
        result_stub = double('result', success?: true, object: author_stub)

        expect(Authors::Update).to(
          receive(:call).with(id: author_id, params: params).and_return(result_stub)
        )

        expected_result = { author: author_stub, errors: [] }
        is_expected.to eq(expected_result)
      end
    end

    context 'when interactor fails' do
      it 'is expected to return fail result with errors' do
        errors_stub = [{ code: 400, path: %i[parameter name], message: 'not valid' }]
        result_stub = double('result', success?: false, errors: errors_stub)

        expect(Authors::Update).to(
          receive(:call).with(id: author_id, params: params).and_return(result_stub)
        )

        expected_result = { author: nil, errors: errors_stub }
        is_expected.to eq(expected_result)
      end
    end
  end
end
