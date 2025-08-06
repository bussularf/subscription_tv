require "rails_helper"

RSpec.describe AdditionalServices::ValidateAdditionalService do
  describe "#call" do
    context "com parâmetros válidos" do
      let(:params) { { name: "Suporte Premium", value: 49.90 } }

      it "cria um serviço adicional e retorna sucesso" do
        result = described_class.new(params: params).call

        expect(result).to be_success
        expect(result.data).to be_a(AdditionalService)
        expect(result.data).to be_persisted
        expect(result.data.name).to eq("Suporte Premium")
        expect(result.data.value).to eq(49.90)
      end
    end

    context "com parâmetros inválidos" do
      let(:params) { { name: "", value: nil } }

      it "retorna erro de validação" do
        result = described_class.new(params: params).call

        expect(result).not_to be_success
        expect(result.data).to be_nil
        expect(result.errors).to include(:name, :value)
        expect(result.errors[:name]).to include("não pode ficar em branco")
        expect(result.errors[:value]).to include("não pode ficar em branco")
      end
    end

    context "com instância existente (update)" do
      let(:existing_service) { AdditionalService.create!(name: "Antigo", value: 20.0) }
      let(:update_params) { { name: "Atualizado", value: 25.5 } }

      it "atualiza o serviço existente e retorna sucesso" do
        result = described_class.new(params: update_params, service: existing_service).call

        expect(result).to be_success
        expect(result.data).to eq(existing_service)
        expect(result.data.name).to eq("Atualizado")
        expect(result.data.value).to eq(25.5)
      end
    end
  end
end
