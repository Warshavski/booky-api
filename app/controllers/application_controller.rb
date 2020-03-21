# frozen_string_literal: true

# ApplicationController
#
#   Used as base controller
#
class ApplicationController < ActionController::API
  before_action :destroy_session

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
