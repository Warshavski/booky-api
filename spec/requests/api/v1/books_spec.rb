# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books management', type: :request do
  let(:base_url) { '/api/v1/books' }
  let(:book_url) { "#{base_url}/#{book.id}" }

  let(:publisher)   { create(:publisher) }
  let(:book)        { create(:book, title: 'some_new_book') }
  let(:book_params) { build(:book_params).merge!(publisher_id: publisher.id) }

  describe 'GET #index' do
    let!(:books) { create_list(:book_seq, 10, publisher: publisher) }

    before(:each) { get base_url }

    context 'unsorted publishers collection' do
      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct quantity' do
        expect(JSON.parse(response.body)['data'].count).to be(10)
      end

      it 'returns correct data format' do
        actual_keys = JSON.parse(response.body)['data'].first.keys
        expected_keys = %w[
          id
          title
          description
          publisher_id
          created_at
          updated_at
          isbn_13
          isbn_10
          published_at
          weight
          pages_count
        ]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'filtered books collection' do
      it 'returns filtered collection by search' do
        get "#{base_url}?search=v7"

        expect(JSON.parse(response.body)['data'].count).to be(1)
        expect(JSON.parse(response.body)['data'].last['title']).to eq('v7')
      end

      it 'returns filtered collection by isbn' do
        book = books.first
        book.update!(isbn_10: '1234567890')

        get "#{base_url}?isbn=1234567890"

        expect(JSON.parse(response.body)['data'].count).to be(1)
        expect(JSON.parse(response.body)['data'].last['title']).to eq(book.title)
      end

      it 'returns filtered collection by isbn' do
        new_publisher = create(:publisher)
        book = create(:book, publisher: new_publisher)

        get "#{base_url}?publisher_id=#{new_publisher.id}"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(1)
        expect(actual_data.last['title']).to eq(book.title)
      end

      it 'returns filtered collection by exact publish date' do
        books.first.update!(published_at: '2016-10-06')

        get "#{base_url}?publish_date=2016-10-06"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(1)
        expect(actual_data.first['title']).to eq('v1')
      end

      it 'returns filtered collection by publish year' do
        books.first.update!(published_at: '2000-10-06')
        books.last.update!(published_at: '2000-12-24')

        get "#{base_url}?publish_date=2000"

        actual_data = JSON.parse(response.body)['data']

        expect(actual_data.count).to be(2)
        expect(actual_data.first['title']).to eq('v1')
      end
    end

    context 'sorted books collection' do
      it 'returns sorted collection by recently_created' do
        get "#{base_url}?sort=created_asc"

        expect(JSON.parse(response.body)['data'].last['title']).to eq('v10')
      end

      it 'returns sorted collection by last_created' do
        get "#{base_url}?sort=created_desc"

        expect(JSON.parse(response.body)['data'].last['title']).to eq('v1')
      end

      it 'returns sorted collection by name ascending' do
        get "#{base_url}?sort=title_asc"

        expect(JSON.parse(response.body)['data'].last['title']).to eq('v9')
      end

      it 'returns sorted collection by name descending' do
        get "#{base_url}?sort=title_desc"

        expect(JSON.parse(response.body)['data'].last['title']).to eq('v1')
      end
    end

    context 'filter and sort' do
      it 'filters books by title and sorts by recently_created' do
        get "#{base_url}?sort=created_desc&search=v"

        result = JSON.parse(response.body)['data']

        expect(result.count).to be(10)
        expect(result.last['title']).to eq('v1')
      end

      it 'filters books by title and sorts by last_created' do
        get "#{base_url}?sort=created_asc&search=v"

        result = JSON.parse(response.body)['data']

        expect(result.count).to be(10)
        expect(result.last['title']).to eq('v10')
      end

      it 'filters books by title and sorts by title descending' do
        get "#{base_url}?sort=title_desc&search=v"

        result = JSON.parse(response.body)['data']

        expect(result.count).to be(10)
        expect(result.first['title']).to eq('v9')
      end

      it 'filters books by title and sorts by title ascending' do
        get "#{base_url}?sort=title_asc&search=v"

        result = JSON.parse(response.body)['data']

        expect(result.count).to be(10)
        expect(result.first['title']).to eq('v1')
      end

      it 'filters books by publish year and sort by title desc' do
        books.first.update!(published_at: '2000-10-06')
        books.last.update!(published_at: '2000-12-24')

        get "#{base_url}?sort=title_desc&publish_date=2000"

        result = JSON.parse(response.body)['data']

        expect(result.count).to be(2)
        expect(result.first['title']).to eq('v10')
      end
    end
  end

  describe 'GET #show' do
    before(:each) { get book_url }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns correct data format' do
      actual_keys = JSON.parse(response.body)['data'].keys
      expected_keys = %w[
        id
        title
        description
        publisher_id
        created_at
        updated_at
        isbn_13
        isbn_10
        published_at
        weight
        pages_count
      ]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns correct expected data' do
      expect(JSON.parse(response.body)['data']['title']).to eq(book.title)
    end

    context 'requests with errors' do
      it 'returns 404 response on not existed publisher' do
        get "#{base_url}/wat_book?"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    before(:each) { post base_url, params: { book: book_params } }

    it 'responds with a 201 status' do
      expect(response).to have_http_status(:created)
    end

    it 'responds with a correct model format' do
      actual_keys = JSON.parse(response.body)['data'].keys
      expected_keys = %w[
        id
        title
        description
        publisher_id
        created_at
        updated_at
        isbn_13
        isbn_10
        published_at
        weight
        pages_count
      ]

      expect(actual_keys).to match_array(expected_keys)
    end

    it 'returns created model' do
      expect(JSON.parse(response.body)['data']['title']).to eq(book_params[:title])
    end

    context 'book presence' do
      it { expect { post base_url, params: { book: book_params } }.to change(Book, :count).by(1) }
    end

    context 'request with not valid params' do
      it 'responds with a 400 status on not presented params' do
        post base_url, params: nil

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on not request without params' do
        post base_url

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on invalid params' do
        post base_url, params: { book: { title: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    before(:each) { put book_url, params: { book: book_params} }

    it 'responds with a 204 status' do
      expect(response).to have_http_status(:no_content)
    end

    it 'updates a book model' do
      expect(book.reload.title).to eq(book_params[:title])
    end

    context 'response with errors' do
      it 'responds with a 404 status not existed book' do
        put "#{base_url}/wat_book?", params: { book: book_params }

        expect(response).to have_http_status(:not_found)
      end

      it 'responds with a 400 status on request with empty params' do
        put book_url, params: nil

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 400 status on request without params' do
        put book_url

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with a 422 status on request with not valid params' do
        put book_url, params: { book: { title: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete book_url

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed book' do
      delete "#{base_url}/wat_book?"

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes publisher' do
      expect { delete book_url }.to change(Book, :count).by(0)
    end
  end
end
