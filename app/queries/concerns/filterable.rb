# frozen_string_literal: true

# Filterable
#
#   Provides filtering logic to the query.
#
module Filterable
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :filter_functions

    def specify_filter(trigger, &block)
      (@filter_functions ||= HashWithIndifferentAccess.new)[trigger] = block
    end
  end

  def filter(collection)
    return collection if self.class.filter_functions.blank?

    filter_params.each do |trigger, filter_value|
      filter_func = self.class.filter_functions[trigger]

      next if filter_func.nil? || filter_value.blank?

      collection = filter_func.call(collection, filter_value)
    end

    collection
  end
end
