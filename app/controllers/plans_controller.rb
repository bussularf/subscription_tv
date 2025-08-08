class PlansController < ApplicationController
  before_action :set_plan, only: [ :show, :edit, :update, :destroy ]

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def show; end

  def edit; end

  def create
    result = Plans::ValidatePlan.new(params: plan_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to plan_path(result.data), notice: t("plans.create.success")
    else
      @plan = Plan.new(plan_params)
      render_error(result)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = Plans::ValidatePlan.new(params: plan_params.to_h.symbolize_keys, plan: @plan).call

    if result.success?
      redirect_to plan_path(@plan), notice: t("plans.update.success")
    else
      render_error(result)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: t("plans.destroy.success")
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :value)
  end

  def render_error(result)
    result.errors.each do |field, messages|
        messages.each do |msg|
          @plan.errors.add(field, msg)
        end
      end
  end
end
