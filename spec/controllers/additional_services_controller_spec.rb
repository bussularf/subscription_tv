require "rails_helper"

RSpec.describe "AdditionalServices", type: :request do
  describe "POST /additional_services" do
    context "com parâmetros válidos" do
      it "cria o serviço e redireciona" do
        post additional_services_path, params: {
          additional_service: {
            name: "Suporte Premium",
            value: 49.9
          }
        }

        follow_redirect!

        expect(response.body).to include("Suporte Premium")
      end
    end

    context "com parâmetros inválidos" do
      it "exibe erros no formulário" do
        post additional_services_path, params: {
          additional_service: {
            name: "",
            value: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("impediram o salvamento do serviço adicional").or include("impediram a criação do serviço adicional")
        expect(response.body).to include("não pode ficar em branco")
      end
    end
  end

  describe "PUT /additional_services/:id" do
    let!(:service) { AdditionalService.create(name: "Entrega rápida", value: 19.9) }

    context "com parâmetros válidos" do
      it "atualiza o serviço e redireciona" do
        put additional_service_path(service), params: {
          additional_service: {
            name: "Entrega expressa",
            value: 29.9
          }
        }

        follow_redirect!

        expect(response.body).to include("Entrega expressa")
      end
    end

    context "com parâmetros inválidos" do
      it "renderiza o form com erros" do
        put additional_service_path(service), params: {
          additional_service: {
            name: "",
            value: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("não pode ficar em branco")
      end
    end
  end
end
