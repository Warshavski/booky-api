require 'rails_helper'

#
#     api_v1_shop_sales POST   /api/v1/shops/:shop_id/sales(.:format)    api/v1/sales#create {:format=>"json"}
#
describe Api::V1::SalesController, 'routing' do
  it 'routes to #create' do
    expect(post('api/v1/shops/1/sales')).to route_to('api/v1/sales#create', shop_id: '1', format: 'json')
  end
end
