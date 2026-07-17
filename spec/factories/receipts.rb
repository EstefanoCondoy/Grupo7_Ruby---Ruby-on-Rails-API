FactoryBot.define do
  factory :receipt do
    association :user
    total { 0 }
  end
end
