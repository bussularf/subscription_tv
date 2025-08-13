FactoryBot.define do
  factory :customer do
    sequence(:name) { |n| "Cliente #{n}" }
    age { rand(0..99) }
  end
end
