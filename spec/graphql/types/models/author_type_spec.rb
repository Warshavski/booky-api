# frozen_string_literal: true

require 'rails_helper'

describe BookySchema.types['Author'] do
  it 'is expected to have the correct fields' do
    expected_fields = %i[
      id created_at updated_at
      first_name last_name biography
      born_in died_in books
    ]

    expect(described_class).to have_graphql_fields(*expected_fields)
  end
end
