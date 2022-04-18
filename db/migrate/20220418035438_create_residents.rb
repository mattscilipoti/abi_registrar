class CreateResidents < ActiveRecord::Migration[7.0]
  def change
    create_table :residents do |t|
      t.string :last_name
      t.text :first_name
      t.text :email_address
      t.datetime :verified_at
      t.boolean :is_deed_holder
      t.boolean :is_renter
      t.boolean :is_minor
      t.text :age_of_minor

      t.timestamps
    end
  end
end
