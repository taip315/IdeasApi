FactoryBot.define do
  factory :category do
    name                  {Faker::String.random(length: 10)}
  end
end