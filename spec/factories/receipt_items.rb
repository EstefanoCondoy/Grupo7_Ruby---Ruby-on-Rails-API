FactoryBot.define do
  factory :receipt_item do
    association :receipt
    association :product
    quantity   { 1 }
    unit_price { product.price }
    subtotal   { unit_price * quantity }
  end
end
