require 'faker'

FactoryBot.define do
  factory :residency do
    property
    resident
    resident_status { :deed_holder }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

    trait :deed_holder do
      resident_status { :deed_holder }
    end

    trait :renter do
      resident_status { :renter }
    end

    trait :verified do
      verified_on { 1.minute.ago }
    end
  end
end
