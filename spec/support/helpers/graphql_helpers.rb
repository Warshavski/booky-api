# frozen_string_literal: true

module GraphqlHelpers
  #
  # Makes an underscored string look like a fieldname
  #
  # "model_name" => "modelName"
  #
  def self.fieldnamerize(underscored_field_name)
    underscored_field_name.to_s.camelize(:lower)
  end
end
