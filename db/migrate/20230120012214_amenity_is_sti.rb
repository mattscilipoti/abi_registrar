class AmenityIsSti < ActiveRecord::Migration[7.0]
  def change
    add_column 'amenities', 'type', :string

    # All current Amenities are Vehicles
    amenity_snapshot_class = Class.new(ApplicationRecord)
    amenity_snapshot_class.table_name = 'amenities'
    say_with_time "Assigning type:'VehicleParkingPass' to ALL amenities" do
      amenity_snapshot_class.update_all(type: VehicleParkingPass.name)
    end
  end
end
