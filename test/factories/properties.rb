FactoryBot.define do
  factory :property do
    street_number { Faker::Address.building_number }
    street_name { "#{Faker::Address.street_name} TEST" }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

    trait :with_lot do
      transient do
        lots_count { 1 }
      end

      after(:create) do |property, evaluator|
        create_list(:lot, evaluator.lots_count, property: property)
      end
    end
  end
end
