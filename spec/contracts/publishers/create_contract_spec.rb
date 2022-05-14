# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Publishers::CreateContract do
  include_context :contract_validation

  let(:default_params) do
    {
      name: 'name#1',
      email: 'email@wat.so',
      phone: '0123456789',
      address: 'address',
      postcode: '9876543210',
      description: 'description'
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: %i[email phone address postcode description]

  it_behaves_like :invalid, without: :name

  it_behaves_like :invalid, with: { name: 0, email: 0, phone: 0, postcode: 0, description: 0 }
  it_behaves_like :invalid, with: { name: '', email: '', phone: '', postcode: '', description: '' }
  it_behaves_like :invalid, with: { name: nil, email: nil, phone: nil, postcode: nil, description: nil }

  it_behaves_like :invalid, with: { postcode: 'code123', email: 'email.com', phone: 'phone' }

  context 'when publisher already exist' do
    before { create(:publisher, name: default_params[:name]) }

    it_behaves_like :invalid
  end
end
