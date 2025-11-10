require 'rails_helper'

RSpec.describe AmenityPassesController, type: :controller do
  let(:factory_name) { :beach_pass }
  let(:assigned_ivar) { :@amenity_passes }

  include_examples 'year filter controller'
end
