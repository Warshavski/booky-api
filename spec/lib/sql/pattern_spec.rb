require 'rails_helper'
require 'sql/pattern'

describe SQL::Pattern do
  let(:dummy) { Class.new { include SQL::Pattern } }

  describe '.to_pattern' do
    context 'when a query is shorter than 3 chars' do
      it 'returns exact matching pattern' do
        expect(dummy.to_pattern('wa')).to eq('wa')
      end

      it 'returns sanitized exact matching pattern' do
        expect(dummy.to_pattern('w_')).to eq('w\_')
      end
    end

    context 'when a query is equal to 3 chars' do
      it 'returns partial matching pattern' do
        expect(dummy.to_pattern('wat')).to eq('%wat%')
      end

      it 'returns sanitized partial matching pattern' do
        expect(dummy.to_pattern('wa_')).to eq('%wa\_%')
      end
    end

    context 'when a query is longer than 3 chars' do
      it 'returns partial matching pattern' do
        expect(dummy.to_pattern('watso')).to eq('%watso%')
      end

      it 'returns sanitized partial matching pattern' do
        expect(dummy.to_pattern('wat_')).to eq('%wat\_%')
      end
    end
  end

  describe '.select_fuzzy_words' do
    subject(:select_fuzzy_words) { User.select_fuzzy_words(query) }

    context 'with a word equal to 3 chars' do
      let(:query) { 'foo' }

      it 'returns array containing a word' do
        expect(select_fuzzy_words).to match_array(['foo'])
      end
    end

    context 'with a word shorter than 3 chars' do
      let(:query) { 'fo' }

      it 'returns empty array' do
        expect(select_fuzzy_words).to match_array([])
      end
    end

    context 'with two words both equal to 3 chars' do
      let(:query) { 'foo baz' }

      it 'returns array containing two words' do
        expect(select_fuzzy_words).to match_array(%w[foo baz])
      end
    end

    context 'with two words divided by two spaces both equal to 3 chars' do
      let(:query) { 'foo  baz' }

      it 'returns array containing two words' do
        expect(select_fuzzy_words).to match_array(%w[foo baz])
      end
    end

    context 'with two words equal to 3 chars and shorter than 3 chars' do
      let(:query) { 'foo ba' }

      it 'returns array containing a word' do
        expect(select_fuzzy_words).to match_array(['foo'])
      end
    end

    context 'with a multi-word surrounded by double quote' do
      let(:query) { '"really bar"' }

      it 'returns array containing a multi-word' do
        expect(select_fuzzy_words).to match_array(['really bar'])
      end
    end

    context 'with a multi-word surrounded by double quote and two words' do
      let(:query) { 'foo "really bar" baz' }

      it 'returns array containing a multi-word and tow words' do
        expect(select_fuzzy_words).to match_array(['foo', 'really bar', 'baz'])
      end
    end

    context 'with a multi-word surrounded by double quote missing a space before the first double quote' do
      let(:query) { 'foo"really bar"' }

      it 'returns array containing two words with double quote' do
        expect(select_fuzzy_words).to match_array(%W[foo"really bar"])
      end
    end

    context 'with a multi-word surrounded by double quote missing a space after the second double quote' do
      let(:query) { '"really bar"baz' }

      it 'returns array containing two words with double quote' do
        expect(select_fuzzy_words).to match_array(%W["really bar"baz])
      end
    end

    context 'with two multi-word surrounded by double quote and two words' do
      let(:query) { 'foo "really bar" baz "awesome feature"' }

      it 'returns array containing two multi-words and tow words' do
        expect(select_fuzzy_words).to match_array(['foo', 'really bar', 'baz', 'awesome feature'])
      end
    end
  end

  describe '.fuzzy_arel_match' do
    subject(:fuzzy_arel_match) { User.fuzzy_arel_match(:username, query) }

    context 'with a word equal to 3 chars' do
      let(:query) { 'foo' }

      it 'returns a single ILIKE condition' do
        expect(fuzzy_arel_match.to_sql).to match(/username.*I?LIKE '\%foo\%'/)
      end
    end

    context 'with a word shorter than 3 chars' do
      let(:query) { 'fo' }

      it 'returns a single equality condition' do
        expect(fuzzy_arel_match.to_sql).to match(/username.*I?LIKE 'fo'/)
      end

      it 'uses LOWER instead of ILIKE when LOWER is enabled' do
        rel = User.fuzzy_arel_match(:username, query, lower_exact_match: true)

        expect(rel.to_sql).to match(/LOWER\(.*username.*\).*=.*'fo'/)
      end
    end

    context 'with two words both equal to 3 chars' do
      let(:query) { 'foo baz' }

      it 'returns a joining LIKE condition using a AND' do
        expect(fuzzy_arel_match.to_sql).to match(/username.+I?LIKE '\%foo\%' AND .*username.*I?LIKE '\%baz\%'/)
      end
    end

    context 'with two words both shorter than 3 chars' do
      let(:query) { 'fo ba' }

      it 'returns a single ILIKE condition' do
        expect(fuzzy_arel_match.to_sql).to match(/username.*I?LIKE 'fo ba'/)
      end
    end

    context 'with two words, one shorter 3 chars' do
      let(:query) { 'foo ba' }

      it 'returns a single ILIKE condition using the longer word' do
        expect(fuzzy_arel_match.to_sql).to match(/username.+I?LIKE '\%foo\%'/)
      end
    end

    context 'with a multi-word surrounded by double quote and two words' do
      let(:query) { 'foo "really bar" baz' }

      it 'returns a joining LIKE condition using a AND' do
        expect(fuzzy_arel_match.to_sql).to match(/username.+I?LIKE '\%foo\%' AND .*username.*I?LIKE '\%baz\%' AND .*username.*I?LIKE '\%really bar\%'/)
      end
    end
  end
end
