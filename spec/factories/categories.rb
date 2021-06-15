FactoryBot.define do
  factory :category do
    name { Faker::Alphanumeric.alpha(number: 10) }
  end
end
