class AmenityIsSti < ActiveRecord::Migration[7.0]
  def change
    add_column 'amenities', 'type', :string

    # All current Amenities are Vehicles
    say_with_time "Assigning type:'Vehicle' to ALL amenities" do
      Amenity.update_all(type: Vehicle.name)
    end
  end
end
