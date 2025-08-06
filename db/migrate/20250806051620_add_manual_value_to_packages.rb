class AddManualValueToPackages < ActiveRecord::Migration[8.0]
  def change
    add_column :packages, :manual_value, :boolean, default: false
  end
end
