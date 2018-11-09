# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include Responder
  include ExceptionHandler
  include JsonApi::RestifyParams

  def process_record(record)
    record.nil? ? not_found : yield(record)
  end

  def filter_params
    params.permit(*(%i[search sort] + specific_filters))
  end

  def specific_filters
    []
  end
end
