require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe DinghyDockStoragePass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  it 'accepts D-12345' do
    pass = FactoryBot.build(:dinghy_dock_storage_pass, resident: resident, sticker_number: 'D-12345')
    expect(pass).to be_valid
  end

  it 'rejects wrong prefix' do
    pass = FactoryBot.build(:dinghy_dock_storage_pass, resident: resident, sticker_number: 'W-12345')
    expect(pass).to be_invalid
  end

  it 'rejects lowercase prefix d-12345' do
    pass = FactoryBot.build(:dinghy_dock_storage_pass, resident: resident, sticker_number: 'd-12345')
    expect(pass).to be_invalid
  end
end
