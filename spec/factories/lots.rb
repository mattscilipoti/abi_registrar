FactoryBot.define do
  factory :lot do
    lot_number { rand(1..975) }
    size { [0.5, 1].sample }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    trait :paid do
      paid_on { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
    end

    trait :unpaid do
      paid_on { nil }
    end
  end
end
