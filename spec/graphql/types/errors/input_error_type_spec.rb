# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookyApiSchema.types['InputError'] do
  it 'is expected to have the correct fields' do
    expected_fields = %i[code path message]

    expect(described_class).to have_graphql_fields(*expected_fields)
  end
end
