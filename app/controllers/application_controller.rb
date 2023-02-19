# frozen_string_literal: true

# Basic application controller
#
class ApplicationController < ActionController::API
  include Handlers::Exception
  #
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  #
  protect_from_forgery with: :null_session

  before_action :destroy_session

  private

  def destroy_session
    request.session_options[:skip] = true
  end
end
