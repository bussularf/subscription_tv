class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :plan, null: true, foreign_key: true
      t.references :package, null: true, foreign_key: true
      t.decimal :value, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
