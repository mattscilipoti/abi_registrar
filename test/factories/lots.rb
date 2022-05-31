FactoryBot.define do
  factory :lot do
    district { '02' } # Arden
    subdivision { '748' } # Arden
    account_number { Faker::Number.number(digits: 8) }
    lot_number { rand(1..975) }
    section { rand(1..4) }
    size { [0.5, 1].sample }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

    trait :paid do
      paid_on { Faker::Time.between(from: 1.year.ago, to: Time.now) }
    end

    trait :unpaid do
      paid_on { nil }
    end
  end
end
