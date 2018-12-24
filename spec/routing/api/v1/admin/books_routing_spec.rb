require 'rails_helper'

#
#   api_v1_admin_books  GET    /api/v1/admin/books(.:format)               api/v1/admin/books#index {:format=>"json"}
#                       POST   /api/v1/admin/books(.:format)               api/v1/admin/books#create {:format=>"json"}
#   api_v1_admin_book   GET    /api/v1/admin/books/:id(.:format)           api/v1/admin/books#show {:format=>"json"}
#                       PATCH  /api/v1/admin/books/:id(.:format)           api/v1/admin/books#update {:format=>"json"}
#                       PUT    /api/v1/admin/books/:id(.:format)           api/v1/admin/books#update {:format=>"json"}
#                       DELETE /api/v1/admin/books/:id(.:format)           api/v1/admin/books#destroy {:format=>"json"}
#
describe Api::V1::Admin::BooksController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/books')).to route_to('api/v1/admin/books#index', format: 'json')
  end

  it 'routes to #show' do
    expect(post('api/v1/admin/books')).to route_to('api/v1/admin/books#create', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/books/1')).to route_to('api/v1/admin/books#show', id: '1', format: 'json')
  end

  it 'routes to #show' do
    expect(patch('api/v1/admin/books/1')).to route_to('api/v1/admin/books#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/admin/books/1')).to route_to('api/v1/admin/books#update', id: '1', format: 'json')
  end

  it 'routes to #delete' do
    expect(delete('api/v1/admin/books/1')).to route_to('api/v1/admin/books#destroy', id: '1', format: 'json')
  end
end
