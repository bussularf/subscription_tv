class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def show; end

  def edit; end

  def create
    result = Customers::ValidateCustomer.new(params: customer_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to customer_path(result.data), notice: t("customers.create.success")
    else
      @customer = Customer.new(customer_params)
      render_error(result)

      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = Customers::ValidateCustomer.new(params: customer_params.to_h.symbolize_keys, customer: @customer).call

    if result.success?
      redirect_to customer_path(result.data), notice: t("customers.update.success")
    else
      render_error(result)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: t("customers.destroy.success")
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :age)
  end

  def render_error(result)
    result.errors.each do |field, messages|
        messages.each do |msg|
          @customer.errors.add(field, msg)
        end
      end
  end
end
