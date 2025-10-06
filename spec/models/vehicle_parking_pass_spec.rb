require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe VehicleParkingPass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  it 'accepts P-12345' do
    pass = FactoryBot.build(:vehicle_parking_pass, resident: resident, sticker_number: 'P-12345')
    expect(pass).to be_valid
  end

  it 'rejects wrong prefix' do
    pass = FactoryBot.build(:vehicle_parking_pass, resident: resident, sticker_number: 'U-12345')
    expect(pass).to be_invalid
  end

  it 'rejects lowercase prefix p-12345' do
    pass = FactoryBot.build(:vehicle_parking_pass, resident: resident, sticker_number: 'p-12345')
    expect(pass).to be_invalid
  end
end
