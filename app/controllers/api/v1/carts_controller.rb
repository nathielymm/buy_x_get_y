module Api
  module V1
    class CartsController < ApplicationController
      def calculate_total
        cart = CreateCartCommand.new(cart_params).call
        service = DiscountCalculatorService.new(cart)
        result = service.apply_discounts

        render json: result
      end

      private

      def cart_params
        params.require(:cart).permit(:reference, lineItems: %i[name price sku])
      end
    end
  end
end
