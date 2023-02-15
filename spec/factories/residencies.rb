require 'faker'

FactoryBot.define do
  factory :residency do
    property
    primary_residence { true }
    resident
    resident_status { :owner }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    # traits for each resident_status are automatically created, thx FactoryBot!
    trait :second_home do
      primary_residence { false }
    end

    trait :verified do
      verified_on { Faker::Time.between(from: 1.year.ago, to: 1.minute.ago) }
    end
  end
end
