FactoryBot.define do
  factory :vehicle do
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: 'MD') }
    sequence(:sticker_number) { |n| 123456 + n }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }
  end
end
