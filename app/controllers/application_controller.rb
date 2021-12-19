# frozen_string_literal: true

# Basic application controller
#
class ApplicationController < ActionController::API
  before_action :destroy_session

  private

  def destroy_session
    request.session_options[:skip] = true
  end
end
