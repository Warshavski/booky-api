# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genres::CreateContract do
  include_context :contract_validation

  let(:default_params) do
    {
      name: 'name#1',
      description: 'description',
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: :description

  it_behaves_like :invalid, without: :name
  it_behaves_like :invalid, with: { name: 0, description: 0 }
  it_behaves_like :invalid, with: { name: '', description: '' }
  it_behaves_like :invalid, with: { name: nil, description: nil }

  context 'when genre already exist' do
    before { create(:genre, name: default_params[:name]) }

    it_behaves_like :invalid
  end
end
