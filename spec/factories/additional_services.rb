FactoryBot.define do
  factory :additional_service do
    sequence(:name) { |n| "Serviço Adicional #{n}" }
    value { 50.0 }
  end
end
