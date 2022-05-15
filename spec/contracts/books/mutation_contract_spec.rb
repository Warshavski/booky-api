# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Books::MutationContract do
  include_context :contract_validation

  let(:default_params) do
    {
      title: 'title',
      description: 'description',
      published_in: '2012-10-10',
      weight: 100,
      pages_count: 300,
      isbn13: '1234567890123',
      isbn10: '1234567890'
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: %i[description weight isbn13 isbn10]

  it_behaves_like :invalid, without: %i[title published_in pages_count]

  it_behaves_like :invalid, with: { title: 0, description: 0, weight: '0', pages_count: '0', isbn13: 'a', isbn10: 'b' }
  it_behaves_like :invalid, with: { title: '', description: '', weight: '0', pages_count: '', isbn13: '', isbn10: '', published_in: '' }
  it_behaves_like :invalid, with: { title: nil, description: nil, weight: nil, pages_count: nil, isbn13: nil, isbn10: nil, published_in: nil }

  it_behaves_like :invalid, with: { isbn10: '12345678', isbn13: '1234567890' }
  it_behaves_like :invalid, with: { isbn10: '1234567890123', isbn13: '1234567890123456' }

  it_behaves_like :invalid, with: { pages_count: -10, weight: -10 }
  it_behaves_like :invalid, with: { published_in: 'date' }
  it_behaves_like :invalid, with: { published_in: Date.current + 1.day }


  context 'when book with given isbn10 exist' do
    before { create(:book, isbn10: default_params[:isbn10]) }

    it_behaves_like :invalid
  end

  context 'when book with given isbn13 exist' do
    before { create(:book, isbn13: default_params[:isbn13]) }

    it_behaves_like :invalid
  end
end
