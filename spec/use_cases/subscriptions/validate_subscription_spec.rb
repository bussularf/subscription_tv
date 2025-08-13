require 'rails_helper'

RSpec.describe Subscriptions::ValidateSubscription do
  let!(:customer) { create(:customer) }
  let!(:package) { create(:package) }
  let!(:additional_service1) { create(:additional_service, name: 'HBO') }
  let!(:additional_service2) { create(:additional_service, name: 'Netflix') }
  let!(:other_service) { create(:additional_service, name: 'Amazon Prime') }

  before do
    package.additional_services << [ additional_service1, additional_service2 ]
  end

  describe '#call' do
    context 'quando cria uma nova assinatura' do
      let(:params) do
        {
          customer_id: 1,
          package_id: package.id,
          additional_service_ids: [ additional_service1.id, other_service.id ]
        }
      end

      it 'retorna erro se adicionar serviço já presente no pacote' do
        result = described_class.new(params: params).call

        expect(result.success?).to eq(false)
        expect(result.errors[:additional_service_ids].first).to include('HBO')
        expect(result.errors[:additional_service_ids].first).not_to include('Amazon Prime')
      end

      it 'cria assinatura com serviços adicionais válidos' do
        valid_params = params.merge(additional_service_ids: [ other_service.id ])
        result = described_class.new(params: valid_params).call

        expect(result.success?).to eq(true)
        expect(result.data.additional_services).to include(other_service)
      end
    end

    context 'quando atualiza uma assinatura existente' do
      let!(:package) { create(:package) }
      let!(:subscription) { create(:subscription, package: package) }

      it 'retorna erro se adicionar serviço duplicado no update' do
        update_params = {
          package_id: package.id,
          additional_service_ids: [ additional_service1.id ]
        }
        result = described_class.new(params: update_params, subscription: subscription).call

        expect(result.success?).to eq(false)
      end

      it 'atualiza com serviços adicionais válidos' do
        update_params = {
          customer_id: customer.id,
          package_id: package.id,
          additional_service_ids: [ other_service.id ]
        }
        result = described_class.new(params: update_params, subscription: subscription).call

        expect(result.success?).to eq(true)
        expect(result.data).to eq(subscription)
        expect(result.data.additional_services).to include(other_service)
      end
    end
  end
end
