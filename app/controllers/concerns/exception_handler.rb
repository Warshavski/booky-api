# ExceptionHandler
#
#   Used to handle ActiveRecord exceptions
#
module ExceptionHandler
  extend ActiveSupport::Concern

  included do

    # Return 400 - Bad Request
    #
    rescue_from ActionController::ParameterMissing do |e|
      log_exception(e)
      bad_request(e.message)
    end

    # Return 404 - Not Found
    #
    rescue_from ActiveRecord::RecordNotFound do |e|
      log_exception(e)
      not_found(e.message)
    end

    # Return 422 - Unprocessable Entity (validation|duplicate record)
    #
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique do |e|
      log_exception(e)
      unprocessable_entity(e.message)
    end

    def bad_request(message)
      render_error(message, :bad_request)
    end

    def not_found(message = 'Record not found')
      render_error(message, :not_found)
    end

    def unprocessable_entity(message)
      render_error(message, :unprocessable_entity)
    end

    private

    def render_error(message, status)
      render json: { error: message }, status: status
    end

    def log_exception(exception)
      application_trace = ActionDispatch::ExceptionWrapper.new(ActiveSupport::BacktraceCleaner.new, exception).application_trace
      application_trace.map! { |t| "  #{t}\n" }

      logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
    end
  end
end
