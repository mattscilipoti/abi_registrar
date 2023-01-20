FactoryBot.define do
  factory :vehicle_parking_pass do
    sequence(:sticker_number) { |n| 123456 + n }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }
  end
end
