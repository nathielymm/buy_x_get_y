require 'rails_helper'

RSpec.describe DiscountConfig, type: :model do
  let(:discount_config) { create(:discount_config) }

  describe 'serialization' do
    it 'correctly serializes and deserializes prerequisite_skus' do
      expect(discount_config.prerequisite_skus).to eq(%w[PEANUT-BUTTER COCOA FRUITY])
      expect(discount_config.eligible_skus).to eq(%w[BANANA-CAKE CHOCOLATE])
    end

    it 'stores arrays as serialized data in the database' do
      saved_config = described_class.find(discount_config.id)

      expect(saved_config.prerequisite_skus).to eq(%w[PEANUT-BUTTER COCOA FRUITY])
      expect(saved_config.eligible_skus).to eq(%w[BANANA-CAKE CHOCOLATE])
    end
  end
end
