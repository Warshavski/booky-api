# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::ConfirmationsController
      #
      #   Used to confirm user registration
      #
      #     - confirms user registration
      #     - generate new confirmation token
      #
      class ConfirmationsController < Devise::ConfirmationsController

        # GET : api/v1/users/confirmation/new
        def new
          route_not_found
        end

        # GET : api/v1/users/confirmation?confirmation_token=abcdef
        #
        # Confirm user registration
        #
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])
          yield resource if block_given?

          if resource.errors.empty?
            set_flash_message!(:notice, :confirmed)
            respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
          else
            respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
          end
        end

        # POST /api/v1/users/confirmation
        #
        # Generate confirmation token
        #
        def create
          self.resource = resource_class.send_confirmation_instructions(resource_params)
          yield resource if block_given?

          if successfully_sent?(resource)
            respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
          else
            respond_with(resource)
          end
        end

        protected

        # The path used after resending confirmation instructions.
        def after_resending_confirmation_instructions_path_for(resource_name)
          is_navigational_format? ? new_session_path(resource_name) : '/'
        end

        # The path used after confirmation.
        def after_confirmation_path_for(resource_name, resource)
          if signed_in?(resource_name)
            signed_in_root_path(resource)
          else
            new_session_path(resource_name)
          end
        end

        def translation_scope
          'devise.confirmations'
        end
      end
    end
  end
end
