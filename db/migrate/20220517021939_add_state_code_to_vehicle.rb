class AddStateCodeToVehicle < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :state_code, :string, :limit => 2
  end
end
