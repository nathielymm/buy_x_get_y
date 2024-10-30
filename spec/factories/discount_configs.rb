FactoryBot.define do
  factory :discount_config do
    prerequisite_skus { ["PEANUT-BUTTER", "COCOA", "FRUITY"] }
    eligible_skus { ["BANANA-CAKE", "CHOCOLATE"] }
    discount_unit { "percentage" }
    discount_value { 50.0 }  
  end
end

