require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe BoatRampAccessPass, type: :model do
  subject(:ramp_pass) { FactoryBot.build(:boat_ramp_access_pass) }

  describe 'to_s' do
    it 'handles nil description (bug)' do
      subject.description = nil
      expect{ subject.to_s }.to_not raise_error
    end
  end
end
