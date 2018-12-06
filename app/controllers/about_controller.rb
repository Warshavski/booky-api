# frozen_string_literal: true

# AboutController
#
#   Used to represent core information about API
#
class AboutController < ApplicationController
  def show
    api_info = {
      version: Booky.version,
      revision: Booky.revision
    }

    render json: { data: api_info }, status: :ok
  end
end
