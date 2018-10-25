# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include ExceptionHandler

  before_action :set_content_type

  def process_record(record)
    record.nil? ? not_found : yield(record)
  end

  def filter_params
    params.permit(*(%i[search sort] + specific_filters))
  end

  def specific_filters
    []
  end

  private

  def set_content_type
    headers['Content-Type'] = 'application/json; charset=utf-8'
  end
end
