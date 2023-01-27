class AmenityIsSti < ActiveRecord::Migration[7.0]
  def change
    add_column 'amenities', 'type', :string

    # All current Amenities are Vehicles
    say_with_time "Assigning type:'VehicleParkingPass' to ALL amenities" do
      AmenityPass.update_all(type: VehicleParkingPass.name)
    end
  end
end
