class CreateCartCommand
  attr_reader :cart_params, :cart

  def initialize(cart_params)
    @cart_params = cart_params
  end

  def call
    ActiveRecord::Base.transaction do
      @cart = Cart.create!(reference: cart_params[:reference])
      cart_params[:lineItems].each do |item|
        cart.line_items.create!(name: item[:name], price: item[:price], sku: item[:sku])
      end
    end
    cart
  end
end
