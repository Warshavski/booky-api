# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'books' do
    let!(:books) { create_pair(:book) }

    let(:query) do
      %(query {
        books {
          edges {
            node {
              title
            }
          }
        }
      })
    end

    subject(:result) do
      BookySchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = books.map { |item| { 'node' => { 'title' => item.title } } }
      actual_results = result.dig('data', 'books', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end
end
