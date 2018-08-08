require 'rails_helper'

RSpec.describe 'Publishers management', type: :request do

  let!(:base_url) { '/api/v1/publishers' }

  let(:publisher)     { create(:publisher) }
  let(:publisher_url) { "#{base_url}/#{publisher.id}" }

  let(:publisher_params) { { publisher: { name: 'some publisher' } } }

  describe 'GET #index' do
    before { create_list(:publisher_seq, 10) }

    context 'unsorted publishers collection' do
      it 'responds with a 200 status' do
        get base_url

        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        get base_url

        expect(JSON.parse(response.body)['data'].count).to eq(10)
      end

      it 'returns correct data format' do
        get base_url

        actual_keys = JSON.parse(response.body)['data'].first.keys
        expected_keys = %w[id name description phone address email postcode created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'filtered publishers collection' do
      it 'returns filtered collection by search' do
        get "#{base_url}?search=v7"

        expect(JSON.parse(response.body)['data'].count).to eq(1)
        expect(JSON.parse(response.body)['data'].last['name']).to eq('v7')
      end
    end

    context 'sorted publishers collection' do
      it 'returns sorted collection by recently_created' do
        get "#{base_url}?sort=created_asc"

        expect(JSON.parse(response.body)['data'].last['name']).to eq('v10')
      end

      it 'returns sorted collection by last_created' do
        get "#{base_url}?sort=created_desc"

        expect(JSON.parse(response.body)['data'].last['name']).to eq('v1')
      end

      it 'returns sorted collection by name ascending' do
        get "#{base_url}?sort=name_asc"

        expect(JSON.parse(response.body)['data'].last['name']).to eq('v9')
      end

      it 'returns sorted collection by name descending' do
        get "#{base_url}?sort=name_desc"

        expect(JSON.parse(response.body)['data'].last['name']).to eq('v1')
      end
    end
  end

  describe 'GET #show' do
    it 'responds with a 200 status' do
      get publisher_url

      expect(response).to have_http_status(:ok)
    end

    it 'returns correct data format' do
      get publisher_url

      actual_keys = JSON.parse(response.body)['data'].keys
      expected_keys = %w[id name description phone address email postcode created_at updated_at]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns correct expected data' do
      get publisher_url

      expect(JSON.parse(response.body)['data']['name']).to eq(publisher.name)
    end

    it 'returns 404 response on not existed publisher' do
      get "#{base_url}/wat_publisher?"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    it 'responds with a 201 status' do
      post base_url, params: publisher_params

      expect(response).to have_http_status(:created)
    end

    it 'responds with a correct model format' do
      post base_url, params: publisher_params

      actual_keys = JSON.parse(response.body)['data'].keys
      expected_keys = %w[id name description phone address email postcode created_at updated_at]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns created model' do
      post base_url, params: publisher_params

      expect(JSON.parse(response.body)['data']['name']).to eq('some publisher')
    end

    it 'responds with a 400 status on not presented params' do
      post base_url, params: nil

      expect(response).to have_http_status(:bad_request)
    end

    it 'responds with a 400 status on not request without params' do
      post base_url

      expect(response).to have_http_status(:bad_request)
    end

    it 'responds with a 422 status on invalid params' do
      post base_url, params: { publisher: { name: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'creates a model' do
      expect { post base_url, params: publisher_params }.to change(Publisher, :count).by(1)
    end
  end

  describe 'PUT #update' do
    it 'responds with a 204 status' do
      put publisher_url, params: publisher_params

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed publisher' do
      put "#{base_url}/wat_publisher?", params: publisher_params

      expect(response).to have_http_status(:not_found)
    end

    it 'responds with a 400 status on request with empty params' do
      put publisher_url, params: nil

      expect(response).to have_http_status(:bad_request)
    end

    it 'responds with a 400 status on request without params' do
      put publisher_url

      expect(response).to have_http_status(:bad_request)
    end

    it 'responds with a 422 status on request with not valid params' do
      put publisher_url, params: { publisher: { name: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'updates a model' do
      put publisher_url, params: publisher_params

      expect(publisher.reload.name).to eq('some publisher')
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete publisher_url

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed publisher' do
      delete "#{base_url}/wat_publisher?"

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes publisher' do
      expect { delete publisher_url }.to change(Publisher, :count).by(0)
    end
  end
end
