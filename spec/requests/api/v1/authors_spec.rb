require 'rails_helper'

RSpec.describe 'Authors management', type: :request do

  let!(:base_url) { '/api/v1/authors' }

  let(:author)        { create(:author) }
  let(:author_url)    { "#{base_url}/#{author.id}" }
  let(:author_params) { { author: build(:author_params) } }

  describe 'GET #index' do
    let!(:authors) { create_list(:author_seq, 10) }

    context 'unsorted authors collection' do
      before(:each) { get base_url }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(JSON.parse(response.body)['data'].count).to be(10)
      end

      it 'returns correct data format' do
        actual_keys = JSON.parse(response.body)['data'].first.keys
        expected_keys = %w[id biography first_name last_name born_in died_in created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'filtered authors collection' do
      let(:book) { create(:book, authors: authors[0..2]) }

      it 'returns filtered collection by search' do
        get "#{base_url}?search=ln-v7"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(1)
        expect(actual_data.last['last_name']).to eq('ln-v7')
      end

      it 'returns filtered collection by book' do
        get "#{base_url}?book_id=#{book.id}"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(3)
        expect(actual_data.last['last_name']).to eq('ln-v3')
      end

      it 'returns filtered collection by book and search' do
        get "#{base_url}?book_id=#{book.id}&search=ln-v2"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(1)
        expect(actual_data.first['last_name']).to eq('ln-v2')
      end
    end

    context 'sorted authors collection' do
      it 'returns sorted collection by recently_created' do
        get "#{base_url}?sort=created_asc"

        expect(JSON.parse(response.body)['data'].last['first_name']).to eq('fn-v10')
      end

      it 'returns sorted collection by last_created' do
        get "#{base_url}?sort=created_desc"

        expect(JSON.parse(response.body)['data'].last['first_name']).to eq('fn-v1')
      end

      it 'returns sorted collection by first_name ascending' do
        get "#{base_url}?sort=first_name_asc"

        expect(JSON.parse(response.body)['data'].last['first_name']).to eq('fn-v9')
      end

      it 'returns sorted collection by first_name descending' do
        get "#{base_url}?sort=first_name_desc"

        expect(JSON.parse(response.body)['data'].last['first_name']).to eq('fn-v1')
      end

      it 'returns sorted collection by last_name ascending' do
        get "#{base_url}?sort=last_name_asc"

        expect(JSON.parse(response.body)['data'].last['last_name']).to eq('ln-v9')
      end

      it 'returns sorted collection by last_name descending' do
        get "#{base_url}?sort=last_name_desc"

        expect(JSON.parse(response.body)['data'].last['last_name']).to eq('ln-v1')
      end
    end
  end

  describe 'GET #show' do
    context 'valid request' do
      before(:each) { get author_url }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct data format' do
        actual_keys = JSON.parse(response.body)['data'].keys
        expected_keys = %w[id biography first_name last_name born_in died_in created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns correct expected data' do
        expect(JSON.parse(response.body)['data']['last_name']).to eq(author.last_name)
      end
    end

    context 'invalid request' do
      it 'returns 404 response on not existed author' do
        get "#{base_url}/wat-author?"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'author presence' do
      it { expect { post base_url, params: author_params }.to change(Author, :count).by(1) }
    end

    context 'valid request' do
      before(:each) { post base_url, params: author_params }

      it 'responds with a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'responds with a correct model format' do
        actual_keys = JSON.parse(response.body)['data'].keys
        expected_keys = %w[id biography first_name last_name born_in died_in created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns created model' do
        expect(JSON.parse(response.body)['data']['first_name']).to eq(author_params.dig(:author, :first_name))
      end
    end

    context 'invalid request' do
      it 'responds with a 400 status on not presented params' do
        post base_url, params: nil

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on not request without params' do
        post base_url

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on invalid first_name' do
        post base_url, params: { author: { first_name: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with a 422 status on invalid last_name' do
        post base_url, params: { author: { last_name: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'valid request' do
      before(:each) { put author_url, params: author_params }

      it 'responds with a 204 status' do
        expect(response).to have_http_status(:no_content)
      end

      it 'updates a model' do
        expect(author.reload.last_name).to eq(author_params.dig(:author,:last_name))
      end
    end

    context 'invalid request' do
      it 'responds with a 404 status not existed author' do
        put "#{base_url}/wat-author?", params: author_params

        expect(response).to have_http_status(:not_found)
      end

      it 'responds with a 400 status on request with empty params' do
        put author_url, params: nil

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on request without params' do
        put author_url

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on request with not valid last_name' do
        put author_url, params: { author: { last_name: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with a 422 status on request with not valid first_name' do
        put author_url, params: { author: { first_name: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete author_url

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed author' do
      delete "#{base_url}/wat_author?"

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes author' do
      expect { delete author_url }.to change(Author, :count).by(0)
    end
  end
end
