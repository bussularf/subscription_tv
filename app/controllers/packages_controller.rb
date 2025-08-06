class PackagesController < ApplicationController
  before_action :set_package, only: [ :edit, :update, :show, :destroy ]

  def index
    @packages = Package.all
  end

  def new
    @package = Package.new
  end

  def edit; end

  def show; end

  def create
    result = Packages::ValidatePackage.new(params: package_params.to_h.symbolize_keys).call

    if result.success?
      redirect_to package_path(result.data), notice: t("packages.create.success")
    else
      @package = Package.new(package_params)
      result.errors.each { |field, messages| Array(messages).each { |msg| @package.errors.add(field, msg) } }
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = Packages::ValidatePackage.new(params: package_params.to_h.symbolize_keys, package: @package).call

    if result.success?
      redirect_to package_path(result.data), notice: t("packages.update.success")
    else
      result.errors.each { |field, messages| Array(messages).each { |msg| @package.errors.add(field, msg) } }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @package.destroy
    redirect_to packages_path, notice: t("packages.destroy.success")
  end

  private

  def set_package
    @package = Package.find(params[:id])
  end

  def package_params
    params.require(:package).permit(:name, :plan_id, :value, :manual_value, additional_service_ids: [])
  end
end
