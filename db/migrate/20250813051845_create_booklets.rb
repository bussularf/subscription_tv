class CreateBooklets < ActiveRecord::Migration[8.0]
  def change
    create_table :booklets do |t|
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
