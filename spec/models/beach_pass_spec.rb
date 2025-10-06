require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe BeachPass, type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }

  it 'allows digits-only sticker_number' do
    pass = FactoryBot.build(:beach_pass, resident: resident, sticker_number: '123456')
    expect(pass).to be_valid
  end

  it 'rejects letter-hyphen format' do
    pass = FactoryBot.build(:beach_pass, resident: resident, sticker_number: 'B-123456')
    expect(pass).to be_invalid
  end

  it 'rejects lowercase prefix with hyphen (b-123456)' do
    pass = FactoryBot.build(:beach_pass, resident: resident, sticker_number: 'b-123456')
    expect(pass).to be_invalid
  end
end
