require 'rails_helper'

RSpec.describe DiscountCalculatorService, type: :service do
  subject(:service) { described_class.new(cart) }

  let(:cart) do
    {
      'lineItems' => line_items.map do |item|
        { 'name' => item.name, 'price' => item.price.to_s, 'sku' => item.sku }
      end
    }
  end

  let(:discount_rule) do
    {
      'discount_value' => '50.0',
      'eligible_skus' => %w[ITEM1 ITEM2],
      'prerequisite_skus' => ['ITEM3']
    }
  end

  let(:discount_rules_json) { discount_rule.to_json }

  before do
    allow(File).to receive(:read).and_return(discount_rules_json)
    allow(Rails.cache).to receive(:fetch).and_return(discount_rule)
  end

  describe '#apply_discounts' do
    context 'when the cart has no eligible items for discount' do
      let(:line_items) do
        [
          build(:line_item, name: 'Item3', price: 100.0, sku: 'ITEM4'),
          build(:line_item, name: 'Item5', price: 150.0, sku: 'ITEM5')
        ]
      end

      it 'returns the original prices for each item and the total price without discount' do
        result = service.apply_discounts
        expected_items = line_items.map do |item|
          { name: item.name, discounted_price: item.price }
        end
        total_price = line_items.sum(&:price)

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end

    context 'when the cart has eligible items but no prerequisite items' do
      let(:line_items) do
        [
          build(:line_item, name: 'Item1', price: 100.0, sku: 'ITEM1'),
          build(:line_item, name: 'Item2', price: 150.0, sku: 'ITEM2')
        ]
      end

      it 'returns the original prices for each item and the total price without discount' do
        result = service.apply_discounts
        expected_items = line_items.map do |item|
          { name: item.name, discounted_price: item.price }
        end
        total_price = line_items.sum(&:price)

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end

    context 'when the cart has only one item' do
      let(:line_items) do
        [
          build(:line_item, name: 'Item1', price: 100.0, sku: 'ITEM1')
        ]
      end

      it 'returns the original price for the single item and the total price without discount' do
        result = service.apply_discounts
        expected_items = line_items.map do |item|
          { name: item.name, discounted_price: item.price }
        end
        total_price = line_items.sum(&:price)

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end

    context 'when the cart has eligible items and a prerequisite item' do
      let(:line_items) do
        [
          build(:line_item, name: 'Item1', price: 100.0, sku: 'ITEM1'),
          build(:line_item, name: 'Item2', price: 200.0, sku: 'ITEM2'),
          build(:line_item, name: 'Item3', price: 300.0, sku: 'ITEM3')
        ]
      end

      it 'applies the discount to the cheapest eligible item' do
        result = service.apply_discounts

        expected_items = [
          { name: 'Item1', discounted_price: 50.0 },
          { name: 'Item2', discounted_price: 200.0 },
          { name: 'Item3', discounted_price: 300.0 }
        ]
        total_price = 50.0 + 200.0 + 300.0

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end
  end
end
