require 'rails_helper'

#
#   api_v1_publisher_shops GET    /api/v1/publishers/:publisher_id/shops(.:format) api/v1/shops#index {:format=>"json"}
#
describe Api::V1::ShopsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/publishers/1/shops')).to route_to('api/v1/shops#index', publisher_id: '1', format: 'json')
  end
end
