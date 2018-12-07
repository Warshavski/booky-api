module Booky
  module Utils
    # Booky::Utils::StrongMemoize
    #
    #   Instead of writing patterns like this:
    #
    #     def user_from_email
    #       return @user if defined?(@user)
    #
    #       @trigger = User.find_by_email(params[:email])
    #     end
    #
    #   We could write it like:
    #
    #     include Booky::Utils::StrongMemoize
    #
    #     def user_from_email
    #       strong_memoize(:email) { User.find_by_email(params[:email]) }
    #     end
    #
    module StrongMemoize
      def strong_memoize(name)
        if ivar_defined?(name)
          instance_variable_get(ivar(name))
        else
          instance_variable_set(ivar(name), yield)
        end
      end

      def clear_memoization(name)
        remove_instance_variable(ivar(name)) if ivar_defined?(name)
      end

      private

      def ivar_defined?(name)
        instance_variable_defined?(ivar(name))
      end

      def ivar(name)
        "@#{name}"
      end
    end
  end
end
