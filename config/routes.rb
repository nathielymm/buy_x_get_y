Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "carts/calculate_total" => "carts#calculate_total"
    end
  end
end
