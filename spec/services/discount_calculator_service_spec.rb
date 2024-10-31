require 'rails_helper'

RSpec.describe DiscountCalculatorService, type: :service do
  subject(:service) { described_class.new(cart) }

  let(:discount_config) { create(:discount_config) }
  let!(:cart) { create(:cart) }

  describe '#apply_discounts' do
    context 'when the cart has no eligible items for discount' do
      before do
        create(:line_item, cart: cart, name: 'Fruity', price: 37.0, sku: 'FRUITY')
        create(:line_item, cart: cart, name: 'Strawberry', price: 37.0, sku: 'STRAWBERRY')
      end

      it 'returns the original prices for each item and the total price without discount' do
        result = service.apply_discounts
        expected_items = cart.line_items.map do |item|
          { name: item.name, discounted_price: item.price }
        end
        total_price = cart.line_items.sum(&:price)

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end

    context 'when the cart has eligible items but no prerequisite items' do
      before do
        create(:line_item, cart: cart, name: 'Peanut-Butter', price: 30.0, sku: 'PEANUT-BUTTER')
        create(:line_item, cart: cart, name: 'Fruity', price: 32.0, sku: 'FRUITY')
      end

      it 'returns the original prices for each item and the total price without discount' do
        result = service.apply_discounts
        expected_items = cart.line_items.map do |item|
          { name: item.name, discounted_price: item.price }
        end
        total_price = cart.line_items.sum(&:price)
        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end

    context 'when the cart has only one item' do
      before do
        create(:line_item, cart: cart, name: 'Cocoa', price: 32.0, sku: 'COCOA')
      end

      it 'returns the original price for the single item and the total price without discount' do
        result = service.apply_discounts
        item = cart.line_items[0]
        expected_item = [{ name: item.name, discounted_price: item.price }]

        expect(result[:items]).to eq(expected_item)
        expect(result[:final_cart_cost]).to eq(expected_item[0][:discounted_price])
      end
    end

    context 'when the cart has eligible items and a prerequisite item' do
      before do
        create(:line_item, cart: cart, name: 'Fruity', price: 32.0, sku: 'FRUITY')
        create(:line_item, cart: cart, name: 'Chocolate', price: 32.0, sku: 'CHOCOLATE')
      end

      it 'applies the discount to the cheapest eligible item' do
        result = service.apply_discounts

        expected_items = [
          { name: 'Fruity', discounted_price: 32.0 },
          { name: 'Chocolate', discounted_price: 16.0 }
        ]

        total_price = expected_items.sum { |item| item[:discounted_price] }

        expect(result[:items]).to eq(expected_items)
        expect(result[:final_cart_cost]).to eq(total_price)
      end
    end
  end
end
