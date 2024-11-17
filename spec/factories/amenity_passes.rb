FactoryBot.define do
  LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'

  factory :beach_pass do
    sequence(:sticker_number) { |n| "B-#{012345 + n}" }
    description { LOREM_IPSUM }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :boat_ramp_access_pass do
    sequence(:sticker_number) { |n| "R-#{123456 + n}" }
    description { LOREM_IPSUM }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :dinghy_dock_storage_pass do
    sequence(:sticker_number) { |n| "D-#{234567 + n}" }
    beach_number { 4 }
    description { LOREM_IPSUM }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :utility_cart_pass do
    sequence(:sticker_number) { |n| "U-#{345678 + n}" }
    description { 'TEST CART' }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :vehicle_parking_pass do
    sequence(:sticker_number) { |n| "P-#{345678 + n}" }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :watercraft_storage_pass do
    sequence(:sticker_number) { |n| "W-#{456789 + n}" }
    beach_number { rand(1..4) }
    description { LOREM_IPSUM }
    location { rand(1..22) }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end
end
