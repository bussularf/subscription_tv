class CustomerContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:age).filled(:integer)
  end

  rule(:age) do
    key.failure(:gteq?, num: 18) if value < 18
  end
end
