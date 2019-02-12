# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::ApplicationController
      #
      #   Base controller for admin section
      #
      class ApplicationController < ::ApplicationController
        prepend_before_action :doorkeeper_authorize!

        before_action :authorize_admin!

        def authorize_admin!
          not_found unless current_user.admin?
        end
      end
    end
  end
end
