# frozen_string_literal: true

module OrderQuery
  # OrderQuery::NullsDirection
  #
  #   Handles nulls :first and :last direction.
  #
  module NullsDirection
    module_function

    DIRECTIONS = %i[first last].freeze

    def all
      DIRECTIONS
    end

    # Reverses direction
    #
    # @param [:first, :last] direction
    #
    # @return [:first, :last]
    #
    # @example
    #
    #   reverse(:first) #=> :last
    #
    def reverse(direction)
      all[(all.index(direction) + 1) % 2].to_sym
    end

    # Ensures direction availability
    #
    # @param [:first, :last] direction
    #
    # @raise [ArgumentError]
    #
    # @return [:last, :first]
    #
    # @example
    #
    #   ensure!(:last) #=> :last
    #
    def ensure!(direction)
      return direction if all.include?(direction)

      message = "`nulls` must be in #{all.map(&:inspect).join(', ')}, is #{direction.inspect}"
      raise ArgumentError, message
    end

    # Default nulls order
    #
    # @param scope [ActiveRecord::Relation]
    #
    # @param dir [:asc, :desc]
    #
    # @return [:first, :last]
    #   the default nulls order, based on the given scope's connection adapter name.
    #
    def default(scope, dir)
      case scope.connection_config[:adapter]
      when /mysql|maria|sqlite|sqlserver/i
        (dir == :asc ? :first : :last)
      else
        # Oracle, Postgres
        (dir == :asc ? :last : :first)
      end
    end
  end
end
