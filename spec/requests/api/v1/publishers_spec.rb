require 'rails_helper'

RSpec.describe 'Publishers management', type: :request do

  let!(:base_url) { '/api/v1/publishers' }

  let(:publisher)     { create(:publisher) }
  let(:publisher_url) { "#{base_url}/#{publisher.id}" }

  let(:publisher_params) { build(:publisher_params) }

  describe 'GET #index' do
    before { create_list(:publisher_seq, 10) }

    context 'unsorted publishers collection' do
      before(:each) { get base_url }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(body_as_json[:data].count).to be(10)
      end

      it 'responds with json-api format' do
        expect(response.body).to look_like_json
        expect(body_as_json[:data].first.keys).to match_array(%w[id type attributes])
      end

      it 'responds with a correct attributes collection' do
        actual_keys = body_as_json[:data].first[:attributes].keys
        expected_keys = %w[name description phone address email postcode created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'filtered publishers collection' do
      it 'returns filtered collection by search' do
        get "#{base_url}?search=v7"

        expect(body_as_json[:data].count).to eq(1)
        expect(body_as_json[:data].last[:attributes][:name]).to eq('v7')
      end
    end

    context 'sorted publishers collection' do
      it 'returns sorted collection by recently_created' do
        get "#{base_url}?sort=created_asc"

        expect(body_as_json[:data].last[:attributes][:name]).to eq('v10')
      end

      it 'returns sorted collection by last_created' do
        get "#{base_url}?sort=created_desc"

        expect(body_as_json[:data].last[:attributes][:name]).to eq('v1')
      end

      it 'returns sorted collection by name ascending' do
        get "#{base_url}?sort=name_asc"

        expect(body_as_json[:data].last[:attributes][:name]).to eq('v9')
      end

      it 'returns sorted collection by name descending' do
        get "#{base_url}?sort=name_desc"

        expect(body_as_json[:data].last[:attributes][:name]).to eq('v1')
      end
    end
  end

  describe 'GET #show' do
    context 'valid request' do
      before(:each) { get publisher_url }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with json-api format' do
        expect(response.body).to look_like_json
        expect(body_as_json[:data].keys).to match_array(%w[id type attributes])
      end

      it 'responds with a correct attributes collection' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[name description phone address email postcode created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns correct expected data' do
        expect(body_as_json[:data][:attributes][:name]).to eq(publisher.name)
      end
    end

    context 'invalid request' do
      it 'returns 404 response on not existed publisher' do
        get "#{base_url}/wat_publisher?"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'valid request parameters' do
      before(:each) { post base_url, params: { data: publisher_params } }

      it 'responds with a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'responds with json-api format' do
        expect(response.body).to look_like_json
        expect(body_as_json[:data].keys).to match_array(%w[id type attributes])
      end

      it 'responds with a correct attributes collection' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[name description phone address email postcode created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns created model' do
        expect(body_as_json[:data][:attributes][:name]).to eq(publisher_params[:attributes][:name])
      end
    end

    context 'invalid request parameters' do
      it 'responds with a 400 status on not presented params' do
        post base_url, params: nil

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on not request without params' do
        post base_url

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on invalid params' do
        publisher_params[:attributes][:name] = nil
        post base_url, params: { data: publisher_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'publisher presence' do
      it { expect { post base_url, params: { data: publisher_params } }.to change(Publisher, :count).by(1) }
    end
  end

  describe 'PUT #update' do
    context 'valid request parameters' do
      before(:each) { put publisher_url, params: { data: publisher_params } }

      it 'responds with a 204 status' do
        expect(response).to have_http_status(:no_content)
      end

      it 'updates a model' do
        expect(publisher.reload.name).to eq(publisher_params[:attributes][:name])
      end
    end

    context 'invalid request parameters' do
      it 'responds with a 404 status not existed publisher' do
        put "#{base_url}/wat_publisher?", params: { data: publisher_params }

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
        publisher_params[:attributes][:name] = nil
        put publisher_url, params: { data: publisher_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
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
