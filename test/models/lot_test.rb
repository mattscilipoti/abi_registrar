require "test_helper"

class LotTest < ActiveSupport::TestCase
  test 'tax_id concatenates district, subdivisoin, and account_number' do
    l = Lot.new(district: 1, subdivision: 123, account_number: 234567)
    assert_equal '01 123 234567', l.tax_id
  end
end
