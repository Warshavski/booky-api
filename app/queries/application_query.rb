# frozen_string_literal: true

# ApplicationQuery
#
#   Used as base class for all queries and contains common logic
#     (sorting and common filtration flow)
#
# TODO : refactor it with DSL for finders
#
class ApplicationQuery
  include Sortable

  specify_sort :default, attributes: :id, direction: :desc

  attr_reader :context, :params

  def initialize(context: nil, params: {})
    @context = context
    @params = params
  end

  def self.call(context: nil, params: {})
    new(context: context, params: params).execute
  end

  def execute
    raise NotImplementedError
  end

  private

  def filter_params
    params || {}
  end
end
