class BillCustomerContract < Dry::Validation::Contract
  params do
    required(:subscription).filled
  end

  rule(:subscription) do
    key.failure("must be a Subscription") unless value.is_a?(Subscription)
  end
end
