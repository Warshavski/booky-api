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
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = books.map { |item| { 'node' => { 'title' => item.title } } }
      actual_results = result.dig('data', 'books', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end

  describe 'genres' do
    let!(:genres) { create_pair(:genre) }

    let(:query) do
      %(query {
        genres {
          edges {
            node {
              name
              description
              createdAt
              updatedAt
            }
          }
        }
      })
    end

    subject(:result) do
      BookyApiSchema.execute(query).as_json
    end

    it 'is expected to return all items' do
      expected_results = genres.map do |item|
        {
          'node' => {
            'name' => item.name,
            'description' => item.description,
            'createdAt' => item.created_at.iso8601,
            'updatedAt' => item.updated_at.iso8601
          }
        }
      end

      actual_results = result.dig('data', 'genres', 'edges')

      expect(actual_results).to match_array(expected_results)
    end
  end
end
