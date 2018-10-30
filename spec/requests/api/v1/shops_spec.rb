require 'rails_helper'

RSpec.describe 'Shops management', type: :request do
  let!(:publisher_with_books) { create(:publisher_with_books, books_count: 2) }

  let(:shop)  { create(:shop) }
  let(:books) { publisher_with_books.books }

  let!(:stocks) { books.map { |b| create(:stock, shop: shop, book: b) } }

  let(:shops_url) { "/api/v1/publishers/#{publisher_with_books.id}/shops" }

  it 'responds with 200 status code' do
    get shops_url

    expect(response).to have_http_status(:ok)
  end

  it 'responds with 404 status code on not existed publisher' do
    get '/api/v1/publishers/wat_publisher_id/shops'

    expect(response).to have_http_status(:not_found)
  end

  it 'responds with expected not found error message' do
    get '/api/v1/publishers/wat_publisher_id/shops'

    expect(body_as_json['errors'].first['detail']).to eq("Couldn't find Publisher with 'id'=wat_publisher_id")
  end

  it 'responds with Array' do
    get shops_url

    expect(JSON.parse(response.body)['shops']).to be_kind_of(Array)
  end

  it 'responds expected shops count' do
    get shops_url

    expect(JSON.parse(response.body)['shops'].count).to be(1)
  end

  it 'responds with correct shop format' do
    get shops_url

    shop_entity = JSON.parse(response.body)['shops'].first

    expect(shop_entity.keys).to match_array(%w[id name books_sold_count books_in_stock])
  end

  it 'responds with correct book_in_stock format' do
    get shops_url

    shop_entity = JSON.parse(response.body)['shops'].first
    book_entity = shop_entity['books_in_stock'].first

    expect(book_entity.keys).to match_array(%w[id title copies_in_stock])
  end
end
