module Packages
  class ValidatePackage
    def initialize(params:, package: nil)
      @params = params
      @package = package
    end

    def call
      validation = PackageContract.new.call(@params)

      if validation.success?
        calculated_value = calculate_total
        input_value = @params[:value].to_f

        is_manual = @params[:manual_value] == "1" || (input_value > 0.0 && calculated_value && input_value != calculated_value)

        final_value = is_manual ? input_value : calculated_value

        data = @package || Package.new
        data.assign_attributes(@params.merge(
          value: final_value,
          manual_value: is_manual
        ))

        if data.save
          ServiceResponse.new(success: true, data: data)
        else
          ServiceResponse.new(success: false, errors: data.errors.to_hash)
        end
      else
        ServiceResponse.new(success: false, errors: validation.errors.to_h)
      end
    end

    private

    def calculate_total
      plan = Plan.find_by(id: @params[:plan_id])
      services = AdditionalService.where(id: @params[:additional_service_ids] || [])

      return nil unless plan && services.any?

      plan.value + services.sum(&:value)
    end
  end
end
