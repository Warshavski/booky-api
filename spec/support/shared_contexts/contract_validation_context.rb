# frozen_string_literal: true

RSpec.shared_context :contract_validation do
  let(:params) do
    cfg = config || {}

    default_params.deep_merge(cfg[:with] || {}).tap do |p|
      without = cfg[:without]

      if without.is_a?(Array) && without[0].is_a?(Hash)
        p = p.dig(*without[0..-2])
        without = without.last
      end

      Array.wrap(without).each { |k| p.delete(k) }
    end
  end

  let(:config) { nil }

  subject(:result) { described_class.new.call(params) }
  subject { result.success? }

  shared_examples :valid do |_config|
    let(:config) { _config }

    it { is_expected.to be }
  end

  shared_examples :invalid do |_config|
    let(:config) { _config }

    it { is_expected.not_to be }
  end
end
