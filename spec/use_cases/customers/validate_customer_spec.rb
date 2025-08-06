require "rails_helper"

RSpec.describe Customers::ValidateCustomer do
  describe "#call" do
    context "com parâmetros válidos" do
      let(:params) { { name: "Maria", age: 28 } }

      it "retorna sucesso e cria um cliente" do
        result = described_class.new(params: params).call

        expect(result).to be_success
        expect(result.data).to be_a(Customer)
        expect(result.data).to be_persisted
        expect(result.data.name).to eq("Maria")
        expect(result.data.age).to eq(28)
        expect(result.errors).to be_nil
      end
    end

    context "com parâmetros inválidos" do
      let(:params) { { name: "", age: "" } }

      it "retorna erro e não cria cliente" do
        result = described_class.new(params: params).call

        expect(result).not_to be_success
        expect(result.data).to be_nil
        expect(result.errors).to include(:name, :age)
        expect(result.errors[:name]).to include("não pode ficar em branco")
        expect(result.errors[:age]).to include("não pode ficar em branco")
      end
    end

    context "com idade abaixo do permitido" do
      let(:params) { { name: "Carlos", age: -1 } }

      it "retorna erro de validação específico para a idade" do
        result = described_class.new(params: params).call

        expect(result).not_to be_success
        expect(result.errors[:age]).to include("deve ser maior ou igual a 18")
      end
    end
  end
end
