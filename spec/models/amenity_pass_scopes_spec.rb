require 'rails_helper'
require 'factory_bot_rails'

class TestAmenityPass < AmenityPass
  self.table_name = 'amenity_passes'
end

RSpec.describe 'AmenityPass sticker_number scopes', type: :model do
  let(:resident) { FactoryBot.create(:resident, :with_paid_properties) }

  it 'identifies valid and invalid across STI types' do
    valid = []
    invalid = []

    valid << FactoryBot.create(:beach_pass, resident: resident, sticker_number: '123456')
    bp_invalid = FactoryBot.create(:beach_pass, resident: resident, sticker_number: '987654')
    bp_invalid.update_column(:sticker_number, 'B-123456')
    invalid << bp_invalid

    valid << FactoryBot.create(:boat_ramp_access_pass, resident: resident, sticker_number: 'R-111')
    br_invalid = FactoryBot.create(:boat_ramp_access_pass, resident: resident, sticker_number: 'R-222')
    br_invalid.update_column(:sticker_number, 'P-111')
    invalid << br_invalid

    valid << FactoryBot.create(:dinghy_dock_storage_pass, resident: resident, sticker_number: 'D-222')
    dd_invalid = FactoryBot.create(:dinghy_dock_storage_pass, resident: resident, sticker_number: 'D-333')
    dd_invalid.update_column(:sticker_number, 'W-222')
    invalid << dd_invalid

    valid << FactoryBot.create(:utility_cart_pass, resident: resident, sticker_number: 'U-333')
    uc_invalid = FactoryBot.create(:utility_cart_pass, resident: resident, sticker_number: 'U-444')
    uc_invalid.update_column(:sticker_number, 'R-333')
    invalid << uc_invalid

    valid << FactoryBot.create(:vehicle_parking_pass, resident: resident, sticker_number: 'P-444')
    vp_invalid = FactoryBot.create(:vehicle_parking_pass, resident: resident, sticker_number: 'P-555')
    vp_invalid.update_column(:sticker_number, 'U-444')
    invalid << vp_invalid

    valid << FactoryBot.create(:watercraft_storage_pass, resident: resident, sticker_number: 'W-555')
    wc_invalid = FactoryBot.create(:watercraft_storage_pass, resident: resident, sticker_number: 'W-666')
    wc_invalid.update_column(:sticker_number, 'D-555')
    invalid << wc_invalid

    # A generic AmenityPass-like subclass (use TestAmenityPass) should accept letter hyphen digits
    valid << FactoryBot.create(:test_amenity_pass, resident: resident, sticker_number: 'A-666')
    ta_invalid = FactoryBot.create(:test_amenity_pass, resident: resident, sticker_number: 'B-777')
    ta_invalid.update_column(:sticker_number, 'AA-666')
    invalid << ta_invalid

    expect(AmenityPass.with_valid_sticker_number).to match_array(valid)
    expect(AmenityPass.with_invalid_sticker_number).to match_array(invalid)
  end
end
