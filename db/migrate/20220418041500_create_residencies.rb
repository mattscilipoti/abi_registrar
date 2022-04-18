class CreateResidencies < ActiveRecord::Migration[7.0]
  def change
    create_table :residencies do |t|
      t.belongs_to :property, null: false, foreign_key: true
      t.belongs_to :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
