FactoryBot.define do
  factory :line_item do
    name { 'Cereal Example' }
    price { rand(32..39) }
    sku { 'CEREAL-EXAMPLE' }

    association :cart
  end
end
