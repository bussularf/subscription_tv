class PackageContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:plan_id).filled(:integer)
    optional(:additional_service_ids).array(:integer)
    optional(:value).maybe(:float)
  end

  rule(:additional_service_ids) do
    if value.nil? || value.empty?
      key.failure(:gteq?)
    end
  end

  rule(:value, :plan_id, :additional_service_ids) do
    if values[:value].nil? && (values[:plan_id].nil? || values[:additional_service_ids].nil?)
      key.failure(:gteq?)
    end
  end
end
