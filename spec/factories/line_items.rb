FactoryBot.define do
  factory :line_item do
    name { 'Peanut Butter' }
    price { '9.99' }
    sku { 'PEANUT-BUTTER' }

    association :cart
  end
end
