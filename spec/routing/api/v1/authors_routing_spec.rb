require 'rails_helper'

#
#         api_v1_authors GET    /api/v1/authors(.:format)         api/v1/authors#index {:format=>"json"}
#                        POST   /api/v1/authors(.:format)         api/v1/authors#create {:format=>"json"}
#          api_v1_author GET    /api/v1/authors/:id(.:format)     api/v1/authors#show {:format=>"json"}
#                        PATCH  /api/v1/authors/:id(.:format)     api/v1/authors#update {:format=>"json"}
#                        PUT    /api/v1/authors/:id(.:format)     api/v1/authors#update {:format=>"json"}
#                        DELETE /api/v1/authors/:id(.:format)     api/v1/authors#destroy {:format=>"json"}
#
describe Api::V1::AuthorsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/authors')).to route_to('api/v1/authors#index', format: 'json')
  end

  it 'routes to #show' do
    expect(post('api/v1/authors')).to route_to('api/v1/authors#create', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/authors/1')).to route_to('api/v1/authors#show', id: '1', format: 'json')
  end

  it 'routes to #show' do
    expect(patch('api/v1/authors/1')).to route_to('api/v1/authors#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/authors/1')).to route_to('api/v1/authors#update', id: '1', format: 'json')
  end

  it 'routes to #delete' do
    expect(delete('api/v1/authors/1')).to route_to('api/v1/authors#destroy', id: '1', format: 'json')
  end
end
