FactoryBot.define do
  factory :subscription do
    association :customer
    value { 100.0 }

    trait :empty do
      plan { nil }
      package { nil }
    end

    trait :with_package do
      plan { nil }
      association :package
    end

    trait :with_plan do
      package { nil }
      association :plan
    end
  end
end
