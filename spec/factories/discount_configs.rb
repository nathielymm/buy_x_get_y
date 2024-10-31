FactoryBot.define do
  factory :discount_config do
    prerequisite_skus { %w[PEANUT-BUTTER COCOA FRUITY] }
    eligible_skus { %w[BANANA-CAKE CHOCOLATE] }
    discount_unit { 'percentage' }
    discount_value { 50.0 }
  end
end
