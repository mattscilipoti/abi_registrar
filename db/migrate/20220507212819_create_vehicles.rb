class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :tag_number
      t.integer :sticker_number
      t.belongs_to :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
