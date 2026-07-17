FactoryBot.define do
  factory :product do
    name        { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 10) }
    price       { Faker::Commerce.price(range: 10.0..999.99) }
    stock       { Faker::Number.between(from: 1, to: 100) }
  end
end
