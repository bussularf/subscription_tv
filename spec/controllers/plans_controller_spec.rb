require "rails_helper"

RSpec.describe PlansController, type: :controller do
  describe "POST #create" do
    context "com parâmetros válidos" do
      let(:valid_params) { { name: "Plano Básico", value: 29.99 } }

      it "cria um novo plano e redireciona" do
        post :create, params: { plan: valid_params }

        plan = Plan.last
        expect(response).to redirect_to(plan_path(plan))
        expect(flash[:notice]).to eq("Plano criado com sucesso.")
        expect(plan.name).to eq("Plano Básico")
        expect(plan.value.to_f).to eq(29.99)
      end
    end

    context "com parâmetros inválidos" do
      let(:invalid_params) { { name: "", value: "" } }

      it "retorna erro e inclui mensagens de validação" do
        post :create, params: { plan: invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    let!(:plan) { Plan.create!(name: "Antigo", value: 10.0) }

    context "com parâmetros válidos" do
      let(:update_params) { { name: "Plano Atualizado", value: 49.90 } }

      it "atualiza o plano e redireciona" do
        put :update, params: { id: plan.id, plan: update_params }

        expect(response).to redirect_to(plan_path(plan))
        expect(flash[:notice]).to eq("Plano atualizado com sucesso.")
        expect(plan.reload.name).to eq("Plano Atualizado")
        expect(plan.reload.value.to_f).to eq(49.90)
      end
    end

    context "com parâmetros inválidos" do
      let(:invalid_params) { { name: "", value: "" } }

      it "retorna erro e inclui mensagens de validação" do
        put :update, params: { id: plan.id, plan: invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
