module SQL
  module Pattern
    extend ActiveSupport::Concern

    MIN_CHARS_FOR_PARTIAL_MATCHING = 3

    module ClassMethods
      def to_pattern(query)
        sanitized_query = sanitize_sql_like(query)

        if partial_matching?(query)
          return "%#{sanitized_query}%"
        end

        sanitized_query
      end

      def partial_matching?(query)
        query.length >= MIN_CHARS_FOR_PARTIAL_MATCHING
      end

      def sanitize_sql_like(string, escape_character = "\\")
        pattern = Regexp.union(escape_character, "%", "_")
        string.gsub(pattern) { |x| [escape_character, x].join }
      end
    end
  end
end
