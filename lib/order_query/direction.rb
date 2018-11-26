# frozen_string_literal: true

module OrderQuery
  # OrderQuery::Direction
  #
  #   Responsible for handling :asc and :desc
  #
  module Direction
    module_function

    DIRECTIONS = %i[asc desc].freeze

    def all
      DIRECTIONS
    end

    # Reverses direction
    #
    # @param [:asc, :desc] direction
    #
    # @return [:asc, :desc]
    #
    # @example
    #
    #   reverse(:asc) #=> :desc
    #
    def reverse(direction)
      all[(all.index(direction) + 1) % 2].to_sym
    end

    # Ensures direction availability
    #
    # @param [:asc, :desc] direction
    #
    # @raise [ArgumentError]
    #
    # @return [:asc, :desc]
    #
    # @example
    #
    #   ensure!(:desc) #=> :desc
    #
    def ensure!(direction)
      return direction if all.include?(direction)

      message = "sort direction must be in #{all.map(&:inspect).join(', ')}, is #{direction.inspect}"
      raise ArgumentError, message
    end
  end
end
