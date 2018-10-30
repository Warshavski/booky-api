# frozen_string_literal: true

# ErrorSerializer
#
#   Used for the errors serialization
#
module ErrorSerializer
  def self.serialize(object, status)
    object.errors.messages.map do |field, errors|
      errors.map do |error_message|
        {
          status: status,
          source: { pointer: "/data/attributes/#{field}" },
          detail: error_message
        }
      end
    end.flatten
  end
end
