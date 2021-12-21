# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookyApiSchema.types['Book'] do
  it 'is expected to have the correct fields' do
    expected_fields = %i[
      id created_at updated_at published_at
      isbn10 isbn13 weight pages_count
      description title publisher authors genres
    ]

    expect(described_class).to have_graphql_fields(*expected_fields)
  end
end
