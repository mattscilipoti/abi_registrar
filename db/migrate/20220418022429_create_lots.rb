class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.integer :district
      t.integer :subdivision
      t.integer :account_number
      t.string :lot_number
      t.integer :section
      t.decimal :size

      t.timestamps
    end
  end
end
