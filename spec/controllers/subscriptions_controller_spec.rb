require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:customer) { create(:customer) }
  let(:plan)     { create(:plan) }
  let(:package)  { create(:package) }
  let(:subscription) { create(:subscription, customer: customer, package: package) }

  describe "PATCH #update" do
    context "quando a validação é bem-sucedida" do
      it "redireciona para a assinatura com mensagem de sucesso" do
        allow(Subscriptions::ValidateSubscription)
          .to receive(:new)
          .and_return(double(call: double(success?: true, data: subscription)))

        patch :update, params: {
          id: subscription.id,
          subscription: {
            customer_id: customer.id,
            plan_id: plan.id,
            package_id: package.id
          }
        }

        expect(response).to redirect_to(subscription_path(subscription))
        expect(flash[:notice]).to eq(I18n.t("packages.update.success"))
      end
    end

    context "quando a validação falha" do
      it "renderiza o template edit com status 422" do
        fake_result = double(
          success?: false,
          errors: { base: [ "Erro fake" ] },
          data: nil
        )

        allow(Subscriptions::ValidateSubscription)
          .to receive(:new)
          .and_return(double(call: fake_result))

        patch :update, params: {
          id: subscription.id,
          subscription: {
            customer_id: customer.id,
            plan_id: plan.id,
            package_id: package.id
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
