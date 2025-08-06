require "rails_helper"

RSpec.describe Plans::ValidatePlan do
  describe "#call" do
    context "com dados válidos" do
      let(:params) { { name: "Premium", value: 99.90 } }

      it "cria o plano com sucesso" do
        result = described_class.new(params: params).call

        expect(result).to be_success
        expect(result.data).to be_persisted
        expect(result.data.name).to eq("Premium")
        expect(result.data.value).to eq(99.90)
      end
    end

    context "com dados inválidos" do
      let(:params) { { name: "", value: nil } }

      it "retorna erros de validação" do
        result = described_class.new(params: params).call

        expect(result).not_to be_success
        expect(result.errors[:name]).to include("não pode ficar em branco")
        expect(result.errors[:value]).to include("não pode ficar em branco")
      end
    end
  end
end
