require 'rails_helper'

#
#           api_v1_books GET    /api/v1/books(.:format)               api/v1/books#index {:format=>"json"}
#                        POST   /api/v1/books(.:format)               api/v1/books#create {:format=>"json"}
#            api_v1_book GET    /api/v1/books/:id(.:format)           api/v1/books#show {:format=>"json"}
#                        PATCH  /api/v1/books/:id(.:format)           api/v1/books#update {:format=>"json"}
#                        PUT    /api/v1/books/:id(.:format)           api/v1/books#update {:format=>"json"}
#                        DELETE /api/v1/books/:id(.:format)           api/v1/books#destroy {:format=>"json"}
#
describe Api::V1::BooksController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/books')).to route_to('api/v1/books#index', format: 'json')
  end

  it 'routes to #show' do
    expect(post('api/v1/books')).to route_to('api/v1/books#create', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/books/1')).to route_to('api/v1/books#show', id: '1', format: 'json')
  end

  it 'routes to #show' do
    expect(patch('api/v1/books/1')).to route_to('api/v1/books#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/books/1')).to route_to('api/v1/books#update', id: '1', format: 'json')
  end

  it 'routes to #delete' do
    expect(delete('api/v1/books/1')).to route_to('api/v1/books#destroy', id: '1', format: 'json')
  end
end
