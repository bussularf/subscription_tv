class SubscriptionContract < Dry::Validation::Contract
  params do
    required(:customer_id).filled(:integer)
    optional(:plan_id).maybe(:integer)
    optional(:package_id).maybe(:integer)
    optional(:service_ids).array(:integer)
  end

  rule(:plan_id, :package_id) do
    if values[:plan_id].present? && values[:package_id].present?
      key.failure("não pode selecionar plano e pacote ao mesmo tempo")
    elsif values[:plan_id].nil? && values[:package_id].nil?
      key.failure("é necessário escolher um plano ou um pacote")
    end
  end

  rule(:service_ids) do
    next unless values[:service_ids]

    if values[:service_ids].uniq.length != values[:service_ids].length
      key.failure("não pode conter serviços repetidos")
    end

    if values[:package_id]
      pacote = Package.find_by(id: values[:package_id])
      if pacote
        servicos_do_pacote = pacote.services.pluck(:id)
        conflito = values[:service_ids] & servicos_do_pacote
        if conflito.any?
          key.failure("não pode conter serviços que já estão no pacote")
        end
      end
    end
  end
end
