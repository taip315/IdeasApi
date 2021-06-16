FactoryBot.define do
  factory :idea do
    body { Faker::Lorem.sentence }
    association :category, factory: :category
  end
end
