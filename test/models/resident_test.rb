require "test_helper"

class ResidentTest < ActiveSupport::TestCase

  test 'lot_fees_paid? when ALL lot fees are paid' do
    resident = FactoryBot.create(:resident, :with_properties, properties_count: 2)
    refute resident.lot_fees_paid?
    assert_equal 2, resident.lots.size

    resident.lots.first.paid_on = 1.day.ago
    refute resident.lot_fees_paid? # only 1 of 2 are paid
    
    resident.lots.each {|lot| lot.paid_on = 1.day.ago }
    assert resident.lot_fees_paid? # both are paid
  end
end
