class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :billable, polymorphic: true, null: false
      t.references :invoice, null: false, foreign_key: true
      t.date :due_date
      t.decimal :value, precision: 10, scale: 2, null: false


      t.timestamps
    end
  end
end
