require "test_helper"

class ShareTransactionTest < ActiveSupport::TestCase
  test 'cost_per defaults to $50' do
    s = ShareTransaction.new
    assert_equal 50, s.cost_per
  end

  test 'validates purchaser is Deed Holder' do
    deed_holder = FactoryBot.build(:residency, resident_status: :deed_holder)
    renter = FactoryBot.build(:residency, resident_status: :renter)

    s = FactoryBot.build(:share_transaction, residency: deed_holder)
    assert s.valid?

    s.residency = renter
    refute s.valid?
    assert_match /must.*Deed Holder/, s.errors[:residency].to_s
  end

  test "when created, increments property share_count by quantity" do
    residency = FactoryBot.create(:residency)
    property = residency.property
    property_shares = property.share_count
    shares = ShareTransaction.create!(quantity: 2, cost_per: 3, residency: residency)

    property.reload
    assert property.share_count > property_shares
    assert_equal property_shares + 2, property.share_count
  end
end
