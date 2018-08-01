# ExceptionHandler
#
#   User to handle ActiveRecord exceptions
#
module ExceptionHandler
  extend ActiveSupport::Concern

  included do

    # Return 404 - Not Found
    #
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: :not_found
    end

    # Return 422 - Unprocessable Entity
    #
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # Return 400 - Bad Request
    #
    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end
  end
end
