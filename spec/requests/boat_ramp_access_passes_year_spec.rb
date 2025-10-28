require 'rails_helper'

RSpec.describe BoatRampAccessPassesController, type: :controller do
  let(:factory_name) { :boat_ramp_access_pass }
  let(:assigned_ivar) { :@boat_ramp_access_passes }

  include_examples 'year filter controller'
end
