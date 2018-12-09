require 'rails_helper'

describe Api::V1::Users::ConfirmationsController do

  describe '#new' do
    it 'responds with not found' do
      get('/api/v1/users/confirmation/new')

      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#show' do; end

  describe '#create' do; end
end
