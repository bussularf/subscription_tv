module Subscriptions
  class ValidateSubscription
    def initialize(params:, subscription: nil)
      @params = params
      @subscription = subscription
    end

    def call
      validation = SubscriptionContract.new.call(@params)

      if validation.success?
        if @subscription
          @subscription.update(@params)
          ServiceResponse.new(success: true, data: @subscription)
        else
          subscription = Subscription.create(@params)
          ServiceResponse.new(success: true, data: subscription)
        end
      else
        ServiceResponse.new(success: false, errors: validation.errors.to_h)
      end
    end
  end
end
