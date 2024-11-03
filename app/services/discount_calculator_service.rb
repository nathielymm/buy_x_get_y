class DiscountCalculatorService
  attr_reader :cart, :discount_config

  def initialize(cart)
    @cart = cart
    @discount_config = DiscountConfig.first
  end

  def apply_discounts
    discounted_items, final_cart_cost = calculate_total

    { items: discounted_items, final_cart_cost: final_cart_cost }
  end

  private

  def calculate_total
    final_cart_cost = 0
    discounted_items = cart.line_items.map do |item|
      discounted_price = calculate_cart_item_discounted_price(item)
      final_cart_cost += discounted_price.round(2)

      { name: item.name, discounted_price: discounted_price.round(2) }
    end

    [discounted_items, final_cart_cost]
  end

  def cart_prerequisite_items
    @cart_prerequisite_items ||= cart.line_items.select { |item| prerequisite_skus.include?(item.sku) }
  end

  def cart_eligible_items
    @cart_eligible_items ||= cart.line_items.select { |item| eligible_skus.include?(item.sku) }
  end

  def find_discountable_cart_item
    return nil if cart_eligible_items.empty? || cart_prerequisite_items.empty?

    combined_unique_count = (cart_eligible_items + cart_prerequisite_items).uniq { |item| item.id }.size
    return nil if combined_unique_count <= 1

    cart_eligible_items.min_by(&:price)
  end

  def calculate_cart_item_discounted_price(item)
    discountable_item = find_discountable_cart_item
    return item.price.to_f unless item == discountable_item

    item.price.to_f * (1 - discount_rate)
  end

  def prerequisite_skus
    discount_config.prerequisite_skus
  end

  def eligible_skus
    discount_config.eligible_skus
  end

  def discount_rate
    discount_config.discount_value.to_f / 100
  end
end
