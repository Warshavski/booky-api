# frozen_string_literal: true

# PaginationFilters
#
#   Used to add pagination filtration to finder
#
module PaginationFilters
  extend ActiveSupport::Concern

  included do
    filter(:page) do |items, params|
      items.page(params[:page]).per(params[:limit] || Booky.config.pagination.limit)
    end

    filter(:limit) do |items, params|
      params[:limit].present? && !params[:page].present? ? items.limit(params[:limit]) : items
    end
  end
end
