class CreateVoidReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :void_reasons do |t|
      t.string  :label, null: false
      t.string  :code
      t.boolean :active, null: false, default: true
      t.integer :position
      t.string  :pass_type
      t.boolean :requires_note, null: false, default: false

      t.timestamps
    end

    add_index :void_reasons, :active
    add_index :void_reasons, :position
    add_index :void_reasons, :code, unique: true

    change_table :amenity_passes do |t|
      t.references :void_reason, foreign_key: true, null: true
    end
  end
end
