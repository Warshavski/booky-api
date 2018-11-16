# frozen_string_literal: true

# PaginationFilters
#
#   Used to add pagination filtration to finder
#
module PaginationFilters
  def paginate_items(items)
    items.page(params[:page] || 1).per(params[:limit] || Booky.config.pagination.limit)
  end

  def filter_by_limit(items)
    params[:limit].present? && !params[:page].present? ? items.limit(params[:limit]) : items
  end
end
