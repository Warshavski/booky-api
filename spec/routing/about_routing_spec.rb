require 'rails_helper'

#
#   root GET    /   api#show
#
describe AboutController, 'routing' do
  it 'routes to #show' do
    expect(get('/')).to route_to('about#show')
  end
end
