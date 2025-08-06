class AdditionalServicesController < ApplicationController
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]

  def index
    @services = AdditionalService.all
  end

  def new
    @service = AdditionalService.new
  end

  def edit; end

  def show; end

  def create
    result = AdditionalServices::ValidateAdditionalService.new(params: service_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to additional_service_path(result.data), notice: t("addition_services.create.success")
    else
      @service = AdditionalService.new(service_params)
      result.errors.each do |field, messages|
        Array(messages).each { |msg| @service.errors.add(field, msg) }
      end

      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = AdditionalServices::ValidateAdditionalService.new(params: service_params.to_h.symbolize_keys, service: @service).call

    if result.success?
      redirect_to additional_service_path(result.data), notice: t("addition_services.update.success")
    else
      result.errors.each do |field, messages|
        Array(messages).each { |msg| @service.errors.add(field, msg) }
      end

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to additional_services_path, notice: t("addition_services.destroy.success")
  end

  private

  def set_service
    @service = AdditionalService.find(params[:id])
  end

  def service_params
    params.require(:additional_service).permit(:name, :value)
  end
end
