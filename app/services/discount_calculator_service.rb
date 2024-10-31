class DiscountCalculatorService
  attr_reader :cart, :discount_config, :cart_prerequisite_item, :discountable_cart_item

  def initialize(cart)
    @cart = cart
    @discount_config = DiscountConfig.first
    @cart_prerequisite_item = find_cart_prerequisite_item
    @discountable_cart_item = find_discountable_cart_item
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

  def find_cart_prerequisite_item
    cart_prerequisite_items = cart.line_items.select { |item| prerequisite_skus.include?(item.sku) }
    select_cart_prerequisite_item(cart_prerequisite_items)
  end

  def select_cart_prerequisite_item(cart_prerequisite_items)
    return if cart_prerequisite_items.empty?

    exclusive_prerequisite = cart_prerequisite_items.find { |item| eligible_skus.exclude?(item.sku) }
    exclusive_prerequisite || cart_prerequisite_items.max_by(&:price)
  end

  def find_discountable_cart_item
    return nil if cart_prerequisite_item.blank?

    cart_eligible_items = cart.line_items.select do |item|
      eligible_skus.include?(item.sku) && item != cart_prerequisite_item
    end

    cart_eligible_items.min_by(&:price)
  end

  def calculate_cart_item_discounted_price(item)
    return item.price.to_f unless item == discountable_cart_item

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
