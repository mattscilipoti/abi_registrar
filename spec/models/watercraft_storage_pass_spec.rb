require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe WatercraftStoragePass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  it 'accepts W-12345' do
    pass = FactoryBot.build(:watercraft_storage_pass, resident: resident, sticker_number: 'W-12345')
    expect(pass).to be_valid
  end

  it 'rejects wrong prefix' do
    pass = FactoryBot.build(:watercraft_storage_pass, resident: resident, sticker_number: 'D-12345')
    expect(pass).to be_invalid
  end

  it 'rejects lowercase prefix w-12345' do
    pass = FactoryBot.build(:watercraft_storage_pass, resident: resident, sticker_number: 'w-12345')
    expect(pass).to be_invalid
  end
end
