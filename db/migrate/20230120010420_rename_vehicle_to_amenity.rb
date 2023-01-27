class RenameVehicleToAmenity < ActiveRecord::Migration[7.0]
  def change
    rename_table 'vehicles', 'amenities'
  end
end
