require "rails_helper"

RSpec.describe "Customers", type: :request do
  let(:valid_attributes) { { name: "João da Silva", age: 30 } }
  let(:invalid_attributes) { { name: "", age: "" } }

  describe "GET /customers" do
    it "retorna todos os clientes" do
      Customer.create!(valid_attributes)
      get customers_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("João da Silva")
    end
  end

  describe "GET /customers/new" do
    it "renderiza o formulário" do
      get new_customer_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("form")
    end
  end

  describe "POST /customers" do
    context "com dados válidos" do
      it "cria um novo cliente e redireciona" do
        post customers_path, params: { customer: valid_attributes }

        expect(response).to redirect_to(customer_path(Customer.last))
        follow_redirect!
        expect(response.body).to include("Cliente criado com sucesso.")
      end
    end

    context "com dados inválidos" do
      it "renderiza o formulário com erros" do
        post customers_path, params: { customer: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /customers/:id/edit" do
    it "renderiza o formulário de edição" do
      customer = Customer.create!(valid_attributes)
      get edit_customer_path(customer)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editar Cliente")
    end
  end

  describe "PUT /customers/:id" do
    let!(:customer) { Customer.create!(valid_attributes) }

    context "com dados válidos" do
      it "atualiza e redireciona" do
        put customer_path(customer), params: { customer: { name: "Novo Nome", age: 40 } }

        expect(response).to redirect_to(customer_path(customer))
        follow_redirect!
        expect(response.body).to include("Cliente atualizado com sucesso.")
      end
    end

    context "com dados inválidos" do
      it "renderiza o formulário de edição com erros" do
        put customer_path(customer), params: { customer: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /customers/:id" do
    it "deleta o cliente e redireciona" do
      customer = Customer.create!(valid_attributes)
      delete customer_path(customer)

      expect(response).to redirect_to(customers_path)
      follow_redirect!
      expect(response.body).to include("Cliente deletado com sucesso.")
    end
  end

  describe "GET /customers/:id" do
    it "exibe o cliente" do
      customer = Customer.create!(valid_attributes)
      get customer_path(customer)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("João da Silva")
    end
  end
end
