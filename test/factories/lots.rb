FactoryBot.define do
  factory :lot do
    district { '02' } # Arden
    subdivision { '748' } # Arden
    account_number { Faker::Number.number(digits: 8) }
    lot_number { rand(1..975) }
    section { rand(1..4) }
    size { [0.5, 1].sample }

    trait :paid do
      paid_on { 1.day.ago }
    end
  end
end