FactoryBot.define do
  factory :package do
    name { "Pacote Exemplo" }
    association :plan
    value { 150.0 }

    transient do
      additional_services_count { 2 }
    end

    after(:build) do |package, evaluator|
      package.additional_services = build_list(:additional_service, evaluator.additional_services_count)
    end
  end
end
