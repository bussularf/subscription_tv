module Plans
  class ValidatePlan
    def initialize(params:, plan: nil)
      @params = params
      @plan = plan
    end

    def call
      validation = PlanContract.new.call(@params)

      if validation.success?
        plan = @plan ? @plan.tap { |p| p.update(@params) } : Plan.create(@params)
        ServiceResponse.new(success: true, data: plan)
      else
        ServiceResponse.new(success: false, errors: validation.errors.to_h)
      end
    end
  end
end
