require 'rails_helper'

#
#   api_v1_admin_authors  GET    /api/v1/admin/authors(.:format)         api/v1/admin/authors#index {:format=>"json"}
#                         POST   /api/v1/admin/authors(.:format)         api/v1/admin/authors#create {:format=>"json"}
#   api_v1_admin_author   GET    /api/v1/admin/authors/:id(.:format)     api/v1/admin/authors#show {:format=>"json"}
#                         PATCH  /api/v1/admin/authors/:id(.:format)     api/v1/admin/authors#update {:format=>"json"}
#                         PUT    /api/v1/admin/authors/:id(.:format)     api/v1/admin/authors#update {:format=>"json"}
#                         DELETE /api/v1/admin/authors/:id(.:format)     api/v1/admin/authors#destroy {:format=>"json"}
#
describe Api::V1::Admin::AuthorsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/authors')).to route_to('api/v1/admin/authors#index', format: 'json')
  end

  it 'routes to #show' do
    expect(post('api/v1/admin/authors')).to route_to('api/v1/admin/authors#create', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/authors/1')).to route_to('api/v1/admin/authors#show', id: '1', format: 'json')
  end

  it 'routes to #show' do
    expect(patch('api/v1/admin/authors/1')).to route_to('api/v1/admin/authors#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/admin/authors/1')).to route_to('api/v1/admin/authors#update', id: '1', format: 'json')
  end

  it 'routes to #delete' do
    expect(delete('api/v1/admin/authors/1')).to route_to('api/v1/admin/authors#destroy', id: '1', format: 'json')
  end
end
