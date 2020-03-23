# frozen_string_literal: true

RSpec::Matchers.define :have_graphql_fields do |*expected|
  def expected_field_names
    Array.wrap(expected).map { |name| GraphqlHelpers.fieldnamerize(name) }
  end

  @allow_extra = false

  chain :only do
    @allow_extra = false
  end

  chain :at_least do
    @allow_extra = true
  end

  match do |kls|
    if @allow_extra
      expect(kls.fields.keys).to include(*expected_field_names)
    else
      expect(kls.fields.keys).to contain_exactly(*expected_field_names)
    end
  end

  failure_message do |kls|
    missing = expected_field_names - kls.fields.keys
    extra = kls.fields.keys - expected_field_names

    message = []

    message << "is missing fields: <#{missing.inspect}>" if missing.any?
    message << "contained unexpected fields: <#{extra.inspect}>" if extra.any? && !@allow_extra

    message.join("\n")
  end
end
