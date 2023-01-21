class RenameAmenityToAmenityPass < ActiveRecord::Migration[7.0]
  def change
    rename_table :amenities, :amenity_passes
  end
end
