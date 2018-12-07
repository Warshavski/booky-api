# frozen_string_literal: true

module SQL
  # SQL::Pattern
  #
  #   Provides additions for search implementation
  #
  module Pattern
    extend ActiveSupport::Concern

    MIN_CHARS_FOR_PARTIAL_MATCHING = 3
    REGEX_QUOTED_WORD = /(?<=\A| )"[^"]+"(?= |\z)/

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

      def sanitize_sql_like(string, escape_character = '\\')
        pattern = Regexp.union(escape_character, '%', '_')
        string.gsub(pattern) { |x| [escape_character, x].join }
      end

      def fuzzy_search(query, columns)
        matches = columns.map { |col| fuzzy_arel_match(col, query) }.compact.reduce(:or)

        where(matches)
      end

      #
      # column - The column name to search in.
      # query - The text to search for.
      # lower_exact_match - When set to `true` we'll fall back to using
      #                     `LOWER(column) = query` instead of using `ILIKE`.
      #
      def fuzzy_arel_match(column, query, lower_exact_match: false)
        query = query.squish
        return nil unless query.present?

        words = select_fuzzy_words(query)

        if words.any?
          words.map { |word| arel_table[column].matches(to_pattern(word)) }.reduce(:and)
        elsif lower_exact_match
          #
          # No words of at least 3 chars, but we can search for an exact
          # case insensitive match with the query as a whole
          #
          Arel::Nodes::NamedFunction.new('LOWER', [arel_table[column]]).eq(query)
        else
          arel_table[column].matches(sanitize_sql_like(query))
        end
      end

      def select_fuzzy_words(query)
        quoted_words = query.scan(REGEX_QUOTED_WORD)

        query = quoted_words.reduce(query) { |q, quoted_word| q.sub(quoted_word, '') }

        words = query.split

        quoted_words.map! { |quoted_word| quoted_word[1..-2] }

        words.concat(quoted_words)

        words.select(&method(:partial_matching?))
      end
    end
  end
end
