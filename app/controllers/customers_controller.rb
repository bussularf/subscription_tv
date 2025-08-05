class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Cliente editado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    result = Customers::CreateCustomer.new(customer_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to customer_path(result.customer), notice: "Cliente criado com sucesso."
    else
      @customer = Customer.new(customer_params)

      result.errors.each do |field, messages|
        Array(messages).each do |msg|
          @customer.errors.add(field, msg)
        end
      end

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Cliente deletado com sucesso."
  end

  def show
  end

  def edit
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :age)
  end
end
