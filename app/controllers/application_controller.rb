# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  include RestifyParams

  include Handlers::Response
  include Handlers::Exception

  before_action :destroy_session
  before_action :check_request_format
  before_action :set_page_title_header

  def check_request_format
    route_not_found unless json_request?
  end

  def process_record(record)
    record.nil? ? not_found : yield(record)
  end

  def route_not_found
    if current_user
      not_found('endpoint does not exists')
    else
      doorkeeper_authorize!
    end
  end

  def not_found(message = 'Record not found')
    render_error([{ status: 404, detail: message }], :not_found)
  end

  def json_request?
    request.format.json?
  end

  def set_page_title_header
    #
    # Per https://tools.ietf.org/html/rfc5987, headers need to be ISO-8859-1, not UTF-8
    #
    response.headers['Page-Title'] = CGI.escape(page_title('Booky'))
  end

  def page_title(*titles)
    @page_title ||= []

    @page_title.push(*titles.compact) if titles.any?

    if titles.any? && !defined?(@breadcrumb_title)
      @breadcrumb_title = @page_title.last
    end

    # Segments are separated by middot
    @page_title.join(" · ")
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

  private

  def destroy_session
    request.session_options[:skip] = true
  end

  def current_resource_owner
    return nil unless doorkeeper_token

    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
  end

  alias current_user current_resource_owner
end
