class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :street_number
      t.string :street_name

      t.timestamps
    end
  end
end
