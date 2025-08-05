module Customers
  class CreateCustomer
    def initialize(params)
      @params = params
    end

    def call
      validation = CustomerContract.new.call(@params)

      if validation.success?
        customer = Customer.create(@params)
        Result.new(success: true, customer: customer)
      else
        Result.new(success: false, errors: validation.errors.to_h)
      end
    end

    class Result
      attr_reader :success, :customer, :errors

      def initialize(success:, customer: nil, errors: nil)
        @success = success
        @customer = customer
        @errors = errors
      end

      def success?
        @success
      end
    end
  end
end
