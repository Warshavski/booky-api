# frozen_string_literal: true

# Sortable
#
#   Provides sorting logic to the query.
#
# Sorting for resource attributes comes 'from the box', no additional configuration needed
#
# To specify a custom sorting:
#
#   class UsersFinder
#     include Sortable
#
#     sorting :name do |scope, direction|
#       scope.order(name: direction, id: :desc)
#     end
#   end
#
# To specify a default sorting:
#
#   class UsersFinder
#     include Sortable
#
#     sorting :default, attributes: %i[id name], direction: :desc
#   end
#
# The sorting block will be called once for each sort attribute/direction requested.
#
# Sort parameters should be provided via: ':sort' key in finder parameters and
# presented by a string like: '-name,id,-createdAt'
#
# NOTE : CamelCase allowed as well as the snake_case
#
module Sortable
  extend ActiveSupport::Concern

  SORT_PARAMETERS_SEPARATOR = ','
  DESC_SIGN = '-'

  private_constant :SORT_PARAMETERS_SEPARATOR, :DESC_SIGN

  class_methods do
    attr_writer :configurations

    def inherited(subclass)
      super(subclass)

      subclass.configurations = configurations.dup if configurations.present?
    end

    def sorting(trigger, attributes: nil, direction: nil, &block)
      configurations[trigger] = pack_configuration(attributes, direction, &block)
    end

    def configurations
      @configurations ||= HashWithIndifferentAccess.new
    end

    private

    def pack_configuration(attributes, direction, &block)
      if block_given?
        block
      else
        { attributes: Array.wrap(attributes), direction: direction }
      end
    end
  end

  included do
    sorting :default, attributes: :id, direction: :asc
  end

  def sort(items)
    each_sort do |attribute, direction|
      next unless supported_sorting?(items, attribute)

      items = perform_sort(items, attribute, direction)
    end

    items
  end

  def each_sort(&block)
    fetch_sort_parameters.each do |parameters_mapping|
      parameters_mapping.flatten.then(&block)
    end
  end

  def fetch_sort_parameters
    params[:sort].blank? ? [default: :asc] : normalize_parameters(params[:sort])
  end

  def normalize_parameters(raw_sort_parameters)
    return raw_sort_parameters if raw_sort_parameters.is_a?(Array)

    raw_sort_parameters
      .split(SORT_PARAMETERS_SEPARATOR)
      .map { |parameter| transform_parameter(parameter) }
  end

  def transform_parameter(parameter)
    direction = parameter[0] == DESC_SIGN ? :desc : :asc
    # TODO : think how to get rid of extra string allocation
    attribute = parameter.sub(DESC_SIGN, '').underscore.to_sym

    { attribute => direction }
  end

  def supported_sorting?(items, attribute)
    items.klass.column_names.include?(attribute.to_s) ||
      self.class.configurations.key?(attribute)
  end

  def perform_sort(scope, attribute, direction)
    configuration = self.class.configurations[attribute]

    unpack_configuration(configuration, scope, direction) do
      scope.order(attribute => direction)
    end
  end

  def unpack_configuration(config, scope, fallback_direction)
    case config
    when Proc
      config.call(scope, fallback_direction)
    when Hash
      direction = config[:direction] || fallback_direction
      params    = config[:attributes].map { |a| { a => direction } }

      scope.order(*params)
    else
      yield
    end
  end
end
