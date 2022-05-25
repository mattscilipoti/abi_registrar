require 'faker'

FactoryBot.define do
  factory :residency do
    property
    resident
    resident_status { :deed_holder }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

    # traits for each resident_status are automatically created, thx FactoryBot!
    
    trait :verified do
      verified_on { Faker::Time.between(from: 1.year.ago, to: 1.minute.ago) }
    end
  end
end
