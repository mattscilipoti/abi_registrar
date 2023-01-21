class AddBeachNumberToAmenity < ActiveRecord::Migration[7.0]
  def change
    add_column :amenities, :beach_number, :integer
  end
end
