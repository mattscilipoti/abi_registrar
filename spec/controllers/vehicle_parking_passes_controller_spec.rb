require 'rails_helper'

RSpec.describe VehicleParkingPassesController, type: :controller do
  let(:factory_name) { :vehicle_parking_pass }
  let(:assigned_ivar) { :@vehicle_parking_passes }

  include_examples 'year filter controller'
end
