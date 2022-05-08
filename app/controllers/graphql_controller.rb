# frozen_string_literal: true

# GraphqlController
#
#   Entry point for GraphQL API
#
class GraphqlController < ApplicationController
  # NOTE: If accessing from outside this domain, nullify the session
  #       This allows for outside API access while preventing CSRF attacks,
  #       but you'll have to authenticate your user separately
  #
  # protect_from_forgery with: :null_session

  # GraphQL entry point
  #
  # "query" and "variables" -
  #   represent a query string and arguments sent by a client respectively;
  #
  # "context" -
  #   is an arbitrary hash, which will be available during the query execution everywhere;
  #   Example: current_user: current_user,
  #
  # "operation_name" -
  #   picks a named operation from the incoming request to execute (could be empty).
  #
  def execute
    args = {
      variables: prepare_variables(params[:variables]),
      context: {},
      operation_name: params[:operationName]
    }

    result = BookyApiSchema.execute(params[:query], **args)

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  #
  def prepare_variables(variables_param) # rubocop:disable Metrics/MethodLength
    case variables_param
    when String
      ensure_string(variables_param)
    when Hash
      variables_param
    when ActionController::Parameters
      # GraphQL-Ruby will validate name and type of incoming variables.
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def ensure_string(variables_param)
    if variables_param.present?
      Oj.parse(variables_param) || {}
    else
      {}
    end
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    body = {
      error: {
        message: error.message,
        backtrace: error.backtrace
      },
      data: {}
    }

    render json: body, status: 500
  end
end
