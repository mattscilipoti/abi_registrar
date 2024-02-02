FactoryBot.define do
  factory :property do
    membership_eligible { true }
    section { rand(1..4) }
    street_number { Faker::Address.building_number }
    street_name { "#{Faker::Address.street_name} TEST" }
    tax_identifier { '%{district} %{subdivision} %{acct_number}' % { acct_number: Faker::Number.number(digits: 8), district: '02', subdivision: '748'} }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    trait :with_paid_lots do
      transient do
        lots_count { 1 }
      end

      after(:create) do |property, evaluator|
        create_list(:lot, evaluator.lots_count, :paid, property: property)
      end
    end

    trait :with_unpaid_lots do
      transient do
        lots_count { 1 }
      end

      after(:create) do |property, evaluator|
        create_list(:lot, evaluator.lots_count, :unpaid, property: property)
      end
    end

    trait :with_owner do
      after(:create) do |property|
        r = create(:resident)
        property.residencies.create(resident_status: :owner, resident: r)
      end
    end

    trait :paid do
      lot_fees_paid_on { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
    end

    trait :unpaid do
      lot_fees_paid_on { nil }
    end
  end
end
