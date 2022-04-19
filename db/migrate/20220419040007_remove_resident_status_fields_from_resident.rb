class RemoveResidentStatusFieldsFromResident < ActiveRecord::Migration[7.0]
  def change
    remove_column :residents, :is_deed_holder
    remove_column :residents, :is_renter
  end
end
