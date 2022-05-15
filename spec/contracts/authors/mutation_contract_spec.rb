# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authors::MutationContract do
  include_context :contract_validation

  let(:default_params) do
    {
      first_name: 'first_name#1',
      last_name: 'last_name',
      biography: 'bio description lorem...',
      born_in: '1900-02-01',
      died_in: '1980-01-21',
      book_ids: %w[1 2 3]
    }
  end

  it_behaves_like :valid
  it_behaves_like :valid, without: %i[biography born_in died_in book_ids]
  it_behaves_like :valid, with: { book_ids: [] }

  it_behaves_like :invalid, without: :first_name
  it_behaves_like :invalid, without: :last_name

  it_behaves_like :invalid, with: { first_name: 0, last_name: 0, biography: 0 }
  it_behaves_like :invalid, with: { first_name: '', last_name: '', biography: '' }
  it_behaves_like :invalid, with: { first_name: nil, last_name: nil, biography: nil }

  it_behaves_like :invalid, with: { born_in: 'code123', died_in: 'date-01-21' }
  it_behaves_like :invalid, with: { born_in: Date.current + 1.day }
  it_behaves_like :invalid, with: { died_in: Date.current + 1.day }
  it_behaves_like :invalid, with: { died_in: Date.current - 2.day, born_in: Date.current - 1.day }

  it_behaves_like :invalid, with: { book_ids: [1, nil, '', 'wat'] }
end
