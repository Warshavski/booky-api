# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  let_it_be(:user) { create(:user) }

  let_it_be(:token) { create(:token, resource_owner_id: user.id) }

  describe '#current_user' do
    it 'returns nil' do
      allow(controller).to receive(:doorkeeper_token).and_return(nil)

      current_user = controller.send(:current_user)

      expect(current_user).to be nil
    end

    it 'returns authenticated user' do
      allow(controller).to receive(:doorkeeper_token).and_return(token)

      current_user = controller.send(:current_user)

      expect(current_user).to eq user
    end
  end
end
