require 'faker'

FactoryBot.define do
  factory :residency do
    property
    resident
    resident_status { :deed_holder }

    trait :renter do
      resident_status { :renter }
    end

    trait :verified do
      verified_on { 1.minute.ago }
    end
  end
end
