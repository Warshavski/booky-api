# frozen_string_literal: true

# GraphqlController
#
#   Entry point for GraphQL API
#
class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = BookyApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end

#
#
# # frozen_string_literal: true
#
# # GraphqlController
# #
# #   Entry point for GraphQL API
# #
# class GraphqlController < ApplicationController
#   # GraphQL entry point
#   #
#   # "query" and "variables" -
#   #   represent a query string and arguments sent by a client respectively;
#   #
#   # "context" -
#   #   is an arbitrary hash, which will be available during the query execution everywhere;
#   #
#   # "operation_name" -
#   #   picks a named operation from the incoming request to execute (could be empty).
#   #
#   def execute
#     args = {
#       variables: ensure_hash(params[:variables]),
#       context: {},
#       operation_name: params[:operationName]
#     }
#
#     result = BookyApiSchema.execute(params[:query], args)
#
#     render json: result
#   rescue StandardError => e
#     raise e unless Rails.env.development?
#
#     handle_error_in_development e
#   end
#
#   private
#
#   #
#   # Handle form data, JSON body, or a blank value
#   #
#   def ensure_hash(ambiguous_param)
#     case ambiguous_param
#     when String
#       ensure_string(ambiguous_param)
#     when Hash, ActionController::Parameters
#       ambiguous_param
#     when nil
#       {}
#     else
#       raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
#     end
#   end
#
#   def ensure_string(ambiguous_param)
#     if ambiguous_param.present?
#       ensure_hash(Oj.load(ambiguous_param))
#     else
#       {}
#     end
#   end
#
#   def handle_error_in_development(error)
#     logger.error error.message
#     logger.error error.backtrace.join("\n")
#
#     body = {
#       error: {
#         message: error.message,
#         backtrace: error.backtrace
#       },
#       data: {}
#     }
#
#     render json: body, status: 500
#   end
# end
