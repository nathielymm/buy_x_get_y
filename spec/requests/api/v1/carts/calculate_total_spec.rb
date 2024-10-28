require 'rails_helper'

RSpec.describe 'Api::V1::Carts::CalculateTotal', type: :request do
  let(:valid_attributes) do
    {
      cart: {
        reference: '2d832fe0-6c96-4515-9be7-4c00983539c1',
        lineItems: [
          { name: 'Peanut Butter', price: '39.0', sku: 'PEANUT-BUTTER' },
          { name: 'Fruity', price: '34.99', sku: 'FRUITY' },
          { name: 'Chocolate', price: '32', sku: 'CHOCOLATE' }
        ]
      }
    }
  end

  describe 'POST /api/v1/cart/calculate_total' do
    context 'when successfully calculate total' do
      subject(:request) do
        post '/api/v1/carts/calculate_total', params: valid_attributes
      end

      it 'sends request successfully' do
        request
        response_json = response.parsed_body

        expect(response).to have_http_status(:ok)
        expect(response_json.keys).to match_array(%w[items final_cart_cost])
      end
    end
  end
end
