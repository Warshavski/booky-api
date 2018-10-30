require 'rails_helper'

RSpec.describe 'Shops management', type: :request do
  let(:shop)  { create(:shop) }
  let(:book)  { create(:book) }

  let!(:stock) { create(:stock, shop: shop, book: book) }

  let(:sales_url) { "/api/v1/shops/#{shop.id}/sales" }

  let(:sale_params) { { sale: { book_id: book.id, quantity: 1 } } }

  it 'responds with 200 status code' do
    post sales_url, params: sale_params

    expect(response).to have_http_status(:created)
  end

  it 'creates new sale' do
    expect { post sales_url, params: sale_params }.to change(Sale, :count).by(1)
  end

  it 'responds created sale entity' do
    post sales_url, params: sale_params

    expect(JSON.parse(response.body)['sale'].keys)
      .to match_array(%w[id book_id shop_id quantity created_at updated_at])
  end

  it 'updates stock quantity' do
    post sales_url, params: sale_params

    expect(stock.reload.quantity).to be(0)
  end

  it 'responds with 404 status code on not existed shop' do
    post '/api/v1/shops/wat_shop_id/sales', params: sale_params

    expect(response).to have_http_status(:not_found)
  end

  it 'responds with expected not found error message' do
    post '/api/v1/shops/wat_shop_id/sales', params: sale_params

    expect(body_as_json['errors'].first['detail']).to eq("Couldn't find Shop with 'id'=wat_shop_id")
  end

  it 'responds 400 status code on invalid quantity params' do
    post sales_url, params: { book_id: 1, quantity: 1000 }

    expect(response).to have_http_status(:bad_request)
  end

  it 'responds 400 status code on invalid book params' do
    post sales_url, params: { book_id: 'wat_book_id', quantity: 1 }

    expect(response).to have_http_status(:bad_request)
  end

  it 'responds 400 status code on not presented params' do
    post sales_url, params: nil

    expect(response).to have_http_status(:bad_request)
  end
end
