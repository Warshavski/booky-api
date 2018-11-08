require 'rails_helper'

#
#      api_v1_publishers GET      /api/v1/publishers(.:format)        api/v1/publishers#index {:format=>"json"}
#                        POST     /api/v1/publishers(.:format)        api/v1/publishers#create {:format=>"json"}
#       api_v1_publisher GET      /api/v1/publishers/:id(.:format)    api/v1/publishers#show {:format=>"json"}
#                        PATCH    /api/v1/publishers/:id(.:format)    api/v1/publishers#update {:format=>"json"}
#                        PUT      /api/v1/publishers/:id(.:format)    api/v1/publishers#update {:format=>"json"}
#                        DELETE   /api/v1/publishers/:id(.:format)    api/v1/publishers#destroy {:format=>"json"}
#
describe Api::V1::PublishersController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/publishers')).to route_to('api/v1/publishers#index', format: 'json')
  end

  it 'routes to #show' do
    expect(post('api/v1/publishers')).to route_to('api/v1/publishers#create', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/publishers/1')).to route_to('api/v1/publishers#show', id: '1', format: 'json')
  end

  it 'routes to #show' do
    expect(patch('api/v1/publishers/1')).to route_to('api/v1/publishers#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/publishers/1')).to route_to('api/v1/publishers#update', id: '1', format: 'json')
  end

  it 'routes to #delete' do
    expect(delete('api/v1/publishers/1')).to route_to('api/v1/publishers#destroy', id: '1', format: 'json')
  end
end
