class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [ :show, :edit, :update, :destroy ]

  def index
    @subscriptions = Subscription.all
  end

  def new
    @subscription = Subscription.new
    @subscription.subscription_additional_services.build
  end

  def show; end

  def edit; end

  def create
    result = Subscriptions::ValidateSubscription.new(params: subscription_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to subscription_path(result.data), notice: t("plans.create.success")
    else
      render_error(result)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = Subscriptions::ValidateSubscription.new(params: subscription_params.to_h.symbolize_keys, subscription: @subscription).call

    if result.success?
      redirect_to subscription_path(result.data), notice: t("packages.update.success")
    else
      render_error(result)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    redirect_to subscriptions_path, notice: t("plans.destroy.success")
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :customer_id,
      :plan_id,
      :package_id,
      :subscription_services_attributes,
      additional_service_ids: []
    )
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def render_error(result)
    @subscription ||= Subscription.new(subscription_params)

    result.errors.each do |field, messages|
        messages.each do |msg|
          @subscription.errors.add(field, msg)
        end
      end
  end
end
