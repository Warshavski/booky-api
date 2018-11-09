# frozen_string_literal: true

require 'rails_helper'
require 'json_api/restify_params'

describe JsonApi::RestifyParams do
  before do
    class FakesController < ActionController::API
      include JsonApi::RestifyParams
    end

    allow(object).to receive(:params).and_return(ActionController::Parameters.new(jsonapi_params))
  end

  after { Object.send :remove_const, :FakesController }

  let(:jsonapi_params) do
    {
      data: {
        id: 1,
        type: 'book',
        attributes: {
          title: 'Title 1',
          description: 'Wat description'
        },
        relationships: {
          publisher: {
            data: { id: 42, type: 'publisher' }
          },
          genres: {
            data: [
              { type: 'genre', id: 2 },
              { type: 'genre', id: 3 }
            ]
          }
        }
      }
    }
  end

  let(:object) { FakesController.new }

  describe '#restify_param' do
    subject { object.restify_param(:book).require(:book) }

    it 'restify parameters without relationships' do
      expected_params = parametrize(title: 'Title 1', description: 'Wat description')

      actual_params = subject.permit(:title, :description)

      expect(actual_params).to eq(expected_params)
    end

    it 'restify parameters with belongs_to relationship' do
      expected_params = parametrize(title: 'Title 1', description: 'Wat description', publisher_id: 42)

      actual_params = subject.permit(:title, :description, :publisher_id)

      expect(actual_params).to eq(expected_params)
    end

    it 'restify parameters with has_many relationship' do
      expected_params = parametrize(title: 'Title 1', description: 'Wat description', genre_ids: [2, 3])

      actual_params = subject.permit(:title, :description, genre_ids: [])

      expect(actual_params).to eq(expected_params)
    end

    it 'restify parameters with belongs_to and has_many relationships' do
      expected_params = parametrize(title: 'Title 1', description: 'Wat description', publisher_id: 42, genre_ids: [2, 3])

      actual_params = subject.permit(:title, :description, :publisher_id, genre_ids: [])

      expect(actual_params).to eq(expected_params)
    end
  end
end
