module AdditionalServices
  class ValidateAdditionalService
    def initialize(params:, service: nil)
      @params = params
      @service = service
    end

    def call
      validation = AdditionalServiceContract.new.call(@params)

      if validation.success?
        if @service
          @service.update(@params)
          ServiceResponse.new(success: true, data: @service)
        else
          service = AdditionalService.create(@params)
          ServiceResponse.new(success: true, data: service)
        end
      else
        ServiceResponse.new(success: false, errors: validation.errors.to_h)
      end
    end
  end
end
