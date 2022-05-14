class AddMiddleNameToResident < ActiveRecord::Migration[7.0]
  def change
    add_column :residents, :middle_name, :string
  end
end
