class AddVoidToAmenityPasses < ActiveRecord::Migration[7.0]
  def change
    add_column :amenity_passes, :voided_at, :datetime
    add_index :amenity_passes, :voided_at
  end
end
