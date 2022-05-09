FactoryBot.define do
  factory :vehicle do
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: 'MD') }
    sequence(:sticker_number) { |n| 123456 + n }

    resident
  end
end
