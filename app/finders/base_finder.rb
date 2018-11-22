# frozen_string_literal: true

# BaseFinder
#
#   Base class for all finders. Encapsulates common filtration logic.
#
class BaseFinder
  attr_reader :params

  def self.filter(trigger, &block)
    (@filters ||= {})[trigger] = block
  end

  def self.filters
    @filters
  end

  def initialize(params = {})
    @params = params
    @collection = ApplicationRecord.none
  end

  def execute
    sort(perform_filtration(@collection))
  end

  protected

  def perform_filtration(collection)
    self.class.filters.values.each do |filter_func|
      collection = filter_func.call(collection, params)
    end

    collection
  end

  private

  def sort(items)
    params[:sort].present? ? items.order_by(params[:sort]) : items.order_by(:created_asc)
  end
end
