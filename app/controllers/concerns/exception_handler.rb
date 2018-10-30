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
      render json: { errors: [{ status: 400, detail: e.message, source: { pointer: e.param }}] },
             status: :bad_request
    end

    # Return 404 - Not Found
    #
    rescue_from ActiveRecord::RecordNotFound do |e|
      log_exception(e)
      render json: { errors: [{ status: 404, detail: e.message}] },
             status: :not_found
    end

    # Return 422 - Unprocessable Entity (validation|duplicate record)
    #
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique do |e|
      log_exception(e)
      render_error(e.record, :unprocessable_entity)
    end

    def not_found(message = 'Record not found')
      render json: { errors: [{status: 404, detail: message }] },
             status: :not_found
    end

    private

    def render_error(object, status)
      render json: { errors: ErrorSerializer.serialize(object, status) }, status: status
    end

    def log_exception(exception)
      application_trace = ActionDispatch::ExceptionWrapper.new(ActiveSupport::BacktraceCleaner.new, exception).application_trace
      application_trace.map! { |t| "  #{t}\n" }

      logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
    end
  end
end
