class AddDescriptionToAmenity < ActiveRecord::Migration[7.0]
  def change
    add_column :amenities, :description, :string
  end
end
