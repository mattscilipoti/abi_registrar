require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe UtilityCartPass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }
  it 'accepts U-12345' do
    pass = FactoryBot.build(:utility_cart_pass, resident: resident, sticker_number: 'U-12345')
    expect(pass).to be_valid
  end

  it 'rejects wrong prefix' do
    pass = FactoryBot.build(:utility_cart_pass, resident: resident, sticker_number: 'R-12345')
    expect(pass).to be_invalid
  end

  it 'rejects lowercase prefix u-12345' do
    pass = FactoryBot.build(:utility_cart_pass, resident: resident, sticker_number: 'u-12345')
    expect(pass).to be_invalid
  end
end
