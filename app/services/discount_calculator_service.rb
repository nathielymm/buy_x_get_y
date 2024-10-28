class DiscountCalculatorService
  DISCOUNT_CONFIG_PATH = Rails.root.join('config/discounts/buy_x_get_y.json')

  attr_reader :cart, :discount_config

  def initialize(cart)
    @cart = cart
    @discount_config = JSON.parse(File.read(DISCOUNT_CONFIG_PATH))
  end

  def apply_discounts
    discounted_items = cart['lineItems'].map do |item|
      { name: item['name'], discounted_price: item_discounted_price(item) }
    end

    total_discounted_price = discounted_items.sum { |item| item[:discounted_price] }

    { items: discounted_items, total_discounted_price: total_discounted_price }
  end

  private

  def item_discounted_price(item)
    if eligible_for_discount?(item)
      item['price'].to_f * (1 - discount_rate)
    else
      item['price'].to_f
    end
  end

  def eligible_for_discount?(item)
    prerequisite_item_present? && eligible_skus.include?(item['sku']) && item == cheapest_eligible_item
  end

  def prerequisite_item_present?
    cart['lineItems'].any? { |item| prerequisite_skus.include?(item['sku']) }
  end

  def cheapest_eligible_item
    @cheapest_eligible_item ||= cart['lineItems']
                                .select { |item| eligible_skus.include?(item['sku']) }
                                .min_by { |item| item['price'].to_f }
  end

  def prerequisite_skus
    discount_config['prerequisite_skus']
  end

  def eligible_skus
    discount_config['eligible_skus']
  end

  def discount_rate
    discount_config['discount_value'].to_f / 100
  end
end
