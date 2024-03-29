# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookyApiSchema.types['Genre'] do
  it 'is expected to have the correct fields' do
    expected_fields = %i[
      id name description created_at updated_at books
    ]

    expect(described_class).to have_graphql_fields(*expected_fields)
  end
end
