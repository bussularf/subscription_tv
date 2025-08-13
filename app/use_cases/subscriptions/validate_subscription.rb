module Subscriptions
  class ValidateSubscription
    def initialize(params:, subscription: nil)
      @params = params
      @subscription = subscription
    end

    def call
      validation = SubscriptionContract.new.call(@params)

      if validation.success?
        @params[:value] = CalculateSubscription.new(@params).call

        if @params[:additional_service_ids].present?
          validation_response = validate_additional_service
          return validation_response unless validation_response.success?
        end

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

    private

    def validate_additional_service
      package_service_ids =
        if @subscription.present?
          @subscription.package.additional_services.ids
        elsif @params[:package_id].present?
          Package.find(@params[:package_id]).additional_services.ids
        else
          []
        end

      new_service_ids = @params[:additional_service_ids].map(&:to_i)

      duplicated_ids = package_service_ids & new_service_ids
      duplicated_names = AdditionalService.where(id: duplicated_ids).pluck(:name)

      if duplicated_ids.present?
        ServiceResponse.new(
          success: false,
          errors: { additional_service_ids: [ "Serviço(s) já presente(s) no pacote: #{duplicated_names.join(', ')}" ] }
        )
      else
        ServiceResponse.new(success: true)
      end
    end
  end
end
