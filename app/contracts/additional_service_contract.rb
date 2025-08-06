class AdditionalServiceContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:value).filled(:float)
  end
end
