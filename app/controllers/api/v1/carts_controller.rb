module Api
  module V1
    class CartsController < ApplicationController
      def calculate_total
        service = DiscountCalculatorService.new(cart_params)
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
