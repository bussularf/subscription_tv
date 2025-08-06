require 'rails_helper'

RSpec.describe Packages::ValidatePackage do
  let(:plan) { create(:plan, value: 100) }
  let(:service1) { create(:additional_service, value: 30) }
  let(:service2) { create(:additional_service, value: 20) }

  let(:valid_params) do
    {
      name: 'Pacote 1',
      plan_id: plan.id,
      additional_service_ids: [ service1.id, service2.id ],
      manual_value: '0'
    }
  end

  context 'quando manual_value é 0 (valor automático)' do
    it 'calcula o valor baseado no plano e nos serviços' do
      result = described_class.new(params: valid_params).call

      expect(result).to be_success
      expect(result.data.value).to eq(150)
    end
  end

  context 'quando manual_value é 1 (valor manual)' do
    it 'usa o valor fornecido manualmente' do
      result = described_class.new(params: valid_params.merge(manual_value: '1', value: 999)).call

      expect(result).to be_success
      expect(result.data.value).to eq(999)
    end
  end

  context 'quando os parâmetros são inválidos' do
    it 'retorna erro de validação' do
      result = described_class.new(params: {}).call

      expect(result).not_to be_success
      expect(result.errors).to be_present
    end
  end

  context 'quando ocorre erro ao salvar o pacote' do
    it 'retorna erro de persistência' do
      result = described_class.new(params: valid_params.except(:name)).call

      expect(result).not_to be_success
      expect(result.errors).to be_present
    end
  end

  context 'quando há um pacote existente sendo atualizado' do
    let(:existing_package) { create(:package, name: 'Antigo', value: 200) }

    it 'atualiza os atributos do pacote existente' do
      result = described_class.new(params: valid_params, package: existing_package).call

      expect(result).to be_success
      expect(result.data).to eq(existing_package)
      expect(result.data.name).to eq('Pacote 1')
    end
  end
end
