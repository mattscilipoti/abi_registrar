require "test_helper"

class ResidentTest < ActiveSupport::TestCase
  test "raises error for negative 'age_of_minor'" do
    exception = assert_raise ActiveRecord::RecordInvalid do
      FactoryBot.create(:resident, :minor, age_of_minor: -1)
    end
    assert_match(/Age of minor must be greater than 0/, exception.message )
  end

  test "raises error for 'age_of_minor' > 13" do
    exception = assert_raise ActiveRecord::RecordInvalid do
      FactoryBot.create(:resident, :minor, age_of_minor: 14)
    end
    assert_match(/Age of minor must be less than 14/, exception.message )
  end

  test "allow nil 'age_of_minor'" do
    r = FactoryBot.create(:resident, :minor)
    assert_nothing_raised do
      r.age_of_minor = nil
      r.save!
    end
  end

  test "allow empty 'age_of_minor'" do
    r = FactoryBot.create(:resident, :minor)
    assert_nothing_raised do
      r.age_of_minor = ''
      r.save!
    end
  end

  test 'lot_fees_paid? when ALL lot fees are paid' do
    resident = FactoryBot.create(:resident, :with_properties, properties_count: 2)

    assert resident.lot_fees_paid? == false

    resident.lots.first.paid_on = 1.day.ago
    assert resident.lot_fees_paid? == false
    
    resident.lots.each {|lot| lot.paid_on = 1.day.ago }
    assert resident.lot_fees_paid?
  end
end
