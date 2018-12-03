# frozen_string_literal: true

module Booky
  # Booky::Database
  #
  #   Provides database-specific functions
  #
  module Database
    def self.nulls_last_order(field, direction = 'ASC')
      order = "#{field} #{direction}"

      if postgresql?
        order = "#{order} NULLS LAST"
      else
        #
        # `field IS NULL` will be `0` for non-NULL columns and `1` for NULL
        # columns. In the (default) ascending order, `0` comes first.
        #
        order = "#{field} IS NULL, #{order}" if direction == 'ASC'
      end

      order
    end

    def self.postgresql?
      adapter_name.casecmp('postgresql').zero?
    end

    def self.adapter_name
      config['adapter']
    end

    def self.config
      ActiveRecord::Base.configurations[Rails.env]
    end
  end
end
