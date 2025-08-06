class CreateJoinTableAdditionalServicesPackages < ActiveRecord::Migration[8.0]
  def change
    create_join_table :additional_services, :packages do |t|
      # t.index [:additional_service_id, :package_id]
      # t.index [:package_id, :additional_service_id]
    end
  end
end
