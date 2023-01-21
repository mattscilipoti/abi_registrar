class AddLocationToAmenity < ActiveRecord::Migration[7.0]
  def change
    add_column :amenities, :location, :string
  end
end
