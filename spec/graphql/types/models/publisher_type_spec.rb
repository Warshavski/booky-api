# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookyApiSchema.types['Publisher'] do
  it 'is expected to have the correct fields' do
    expected_fields = %i[
      id created_at updated_at
      name description email phone address postcode books
    ]

    expect(described_class).to have_graphql_fields(*expected_fields)
  end
end
