require "rails_helper"

RSpec.describe PackagesController, type: :controller do
  describe "POST #create" do
    let!(:plan) { Plan.create!(name: "Plano Básico", value: 100) }
    let!(:service1) { AdditionalService.create!(name: "Serviço 1", value: 50) }
    let(:valid_params) do
      {
        package: {
          name: "Pacote Teste",
          plan_id: plan.id,
          additional_service_ids: [ service1.id ],
          manual_value: "0"
        }
      }
    end

    let(:invalid_params) do
      {
        package: {
          name: "",
          plan_id: nil,
          additional_service_ids: [],
          manual_value: "0"
        }
      }
    end

    context "com parâmetros válidos" do
      it "cria um novo pacote e redireciona" do
        expect {
          post :create, params: valid_params
        }.to change(Package, :count).by(1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(package_path(Package.last))
      end
    end

    context "com parâmetros inválidos" do
      it "não cria o pacote e retorna erro" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Package, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
