class CreateSubscriptionAdditionalServices < ActiveRecord::Migration[8.0]
  def change
    create_table :subscription_additional_services do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :additional_service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
