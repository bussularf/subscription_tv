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
      render_error(result)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = Packages::ValidatePackage.new(params: package_params.to_h.symbolize_keys, package: @package).call

    if result.success?
      redirect_to package_path(result.data), notice: t("packages.update.success")
    else
      render_error(result)
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

  def render_error(result)
    result.errors.each do |field, messages|
        messages.each do |msg|
          @package.errors.add(field, msg)
        end
      end
  end
end
