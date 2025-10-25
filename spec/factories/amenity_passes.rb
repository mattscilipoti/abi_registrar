require_relative 'factory_helpers'

FactoryBot.define do
  LOREM_IPSUM = 'Lorem ipsum dolor sit amet' #, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'

  factory :beach_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('B', n, n_width: 4) }
    description { LOREM_IPSUM }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :boat_ramp_access_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('R', n, n_width: 4) }
    description { LOREM_IPSUM }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :dinghy_dock_storage_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('D', n, n_width: 4) }
    beach_number { 4 }
    description { LOREM_IPSUM }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :utility_cart_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('U', n, n_width: 4) }
    description { 'TEST CART' }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :vehicle_parking_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('P', n, n_width: 4) }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end

  factory :watercraft_storage_pass do
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('W', n, n_width: 4) }
    beach_number { rand(1..4) }
    description { LOREM_IPSUM }
    location { rand(1..22) }

    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }
  end
end
