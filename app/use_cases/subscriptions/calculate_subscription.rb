module Subscriptions
  class CalculateSubscription
    def initialize(params)
      @plan_id = params[:plan_id]
      @package_id = params[:package_id]
      @additional_service_ids = params[:additional_service_ids] || []
    end

    def call
      calculate_value
    end

    private

    def calculate_value
      base_price = 0

      if @plan_id.present?
        base_price += Plan.find(@plan_id).value
      elsif @package_id.present?
        base_price += Package.find(@package_id).value
      end

      additional_services = AdditionalService.where(id: @additional_service_ids)
      base_price += additional_services.sum(:value)

      base_price
    end
  end
end
