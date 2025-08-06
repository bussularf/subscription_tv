module Customers
  class ValidateCustomer
    def initialize(params:, customer: nil)
      @params = params
      @customer = customer
    end

    def call
      validation = CustomerContract.new.call(@params)

      if validation.success?
        if @customer
          @customer.update(@params)
          ServiceResponse.new(success: true, data: @customer)
        else
          customer = Customer.create(@params)
          ServiceResponse.new(success: true, data: customer)
        end
      else
        ServiceResponse.new(success: false, errors: validation.errors.to_h)
      end
    end
  end
end
