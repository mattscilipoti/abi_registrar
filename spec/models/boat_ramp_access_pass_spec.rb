require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe BoatRampAccessPass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  subject(:ramp_pass) { FactoryBot.build(:boat_ramp_access_pass, resident: resident) }

  describe 'to_s' do
    it 'handles nil description (bug)' do
      subject.description = nil
      expect{ subject.to_s }.to_not raise_error
    end
  end

  describe 'sticker_number format' do
    it 'accepts R-12345' do
      ramp_pass.sticker_number = 'R-12345'
      expect(ramp_pass).to be_valid
    end

    it 'rejects wrong prefix' do
      ramp_pass.sticker_number = 'P-12345'
      expect(ramp_pass).to be_invalid
    end

    it 'rejects lowercase prefix r-12345' do
      ramp_pass.sticker_number = 'r-12345'
      expect(ramp_pass).to be_invalid
    end
  end
end
