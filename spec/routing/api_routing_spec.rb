require 'rails_helper'

#
#   root GET    /   api#show
#
describe ApiController, 'routing' do
  it 'routes to #show' do
    expect(get('/')).to route_to('api#show')
  end
end
