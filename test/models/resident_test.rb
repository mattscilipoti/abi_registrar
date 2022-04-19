require "test_helper"

class ResidentTest < ActiveSupport::TestCase
  test "raises error for negative 'age_of_minor'" do
    exception = assert_raise ActiveRecord::RecordInvalid do
      Resident.create!(age_of_minor: 0)
    end
    assert_match(/Age of minor must be greater than 0/, exception.message )
  end

  test "raises error for 'age_of_minor' > 13" do
    exception = assert_raise ActiveRecord::RecordInvalid do
      Resident.create!(age_of_minor: 14)
    end
    assert_match(/Age of minor must be less than 14/, exception.message )
  end

  test "allow nil 'age_of_minor'" do
    r = Resident.create!(age_of_minor: 13)
    assert_nothing_raised do
      r.age_of_minor = nil
      r.save!
    end
  end

  test "allow empty 'age_of_minor'" do
    r = Resident.create!(age_of_minor: 13)
    assert_nothing_raised do
      r.age_of_minor = ''
      r.save!
    end
  end
end
