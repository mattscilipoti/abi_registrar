class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.string :type
      t.money :cost_per, default: 0
      t.integer :quantity, default: 0
      t.money :cost_total, default: 0
      t.datetime :purchased_at
      t.belongs_to :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
