class AddVoidReasonToAmenityPasses < ActiveRecord::Migration[7.0]
  def change
    add_column :amenity_passes, :voided_reason, :string
  end
end
