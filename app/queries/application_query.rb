# frozen_string_literal: true

# ApplicationQuery
#
#   Used as base class for all queries and contains common logic
#     (sorting and common filtration flow)
#
class ApplicationQuery
  include Sortable
  include Filterable

  class << self
    attr_reader :default_scope

    def options(options)
      @default_scope = options[:default_scope]
    end
  end

  specify_sort :default, attributes: :id, direction: :desc

  attr_reader :context, :params

  def initialize(context: nil, params: {})
    @context = context || self.class.default_scope
    @params = params
  end

  def self.call(context: nil, params: {})
    new(context: context, params: params).execute
  end

  def execute
    filter(context).then(&method(:sort))
  end

  private

  def filter_params
    params || {}
  end
end
