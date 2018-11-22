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

  # Optional query parameters :
  #
  #   - search  filter by given term(pattern)
  #               example: ?search=term
  #
  #   - sort    sort by attribute and direction
  #               example: ?sort=name_asc
  #
  #   - page    filter by page number
  #               example: ?page=1
  #
  #   - limit   limit items in collection
  #               example: ?limit=1
  #
  def filter_params
    params.permit(*(%i[search sort page limit] + specific_filters))
  end

  def specific_filters
    []
  end
end
