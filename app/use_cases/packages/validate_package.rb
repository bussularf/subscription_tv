module Packages
  class ValidatePackage
    def initialize(params:, package: nil)
      @params = params
      @package = package
    end

    def call
      validation = PackageContract.new.call(@params)

      if validation.success?
        calculated_value = if @params[:manual_value] == "1"
          @params[:value]
        else
          calculate_total
        end

        data = @package || Package.new
        data.assign_attributes(@params.merge(value: calculated_value))

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
