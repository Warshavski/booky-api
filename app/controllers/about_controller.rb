# frozen_string_literal: true

# AboutController
#
#   Used to represent core information about API
#
class AboutController < ApplicationController
  def show
    api_info = {
      version: '0.0.1',
      revision: ''
    }

    render json: { data: api_info }, status: :ok
  end
end
