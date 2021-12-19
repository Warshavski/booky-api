# frozen_string_literal: true

require 'rails_helper'

describe CaseSensible do
  describe '.iwhere' do
    let_it_be(:connection) { ActiveRecord::Base.connection }

    let_it_be(:model) do
      Class.new(ActiveRecord::Base) do
        include CaseSensible

        self.table_name = 'authors'
      end
    end

    let_it_be(:first_model)  { model.create(first_name: 'mOdEl-1', last_name: 'mOdEl 1') }
    let_it_be(:second_model) { model.create(first_name: 'mOdEl-2', last_name: 'mOdEl 2') }

    it 'finds a single instance by a single attribute regardless of case' do
      expect(model.iwhere(first_name: 'MODEL-1')).to contain_exactly(first_model)
    end

    it 'finds multiple instances by a single attribute regardless of case' do
      expect(model.iwhere(first_name: %w[MODEL-1 model-2])).to(
        contain_exactly(first_model, second_model)
      )
    end

    it 'finds instances by multiple attributes' do
      expect(model.iwhere(first_name: %w[MODEL-1 model-2], last_name: 'model 1')).to(
        contain_exactly(first_model)
      )
    end
  end
end
