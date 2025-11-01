require_relative 'factory_helpers'

FactoryBot.define do
  LOREM_IPSUM = 'Lorem ipsum dolor sit amet' #, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  # Shared trait for amenity pass attributes and callbacks
  trait :amenity_pass_base do
    description { LOREM_IPSUM }
    resident

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    after(:build) do |pass|
      FactoryHelpers.ensure_property_with_mandatory_fees(pass.resident)
    end
  end

  factory :beach_pass, class: 'BeachPass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('B', n, n_width: 4) }
  end

  factory :boat_ramp_access_pass, class: 'BoatRampAccessPass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('R', n, n_width: 4) }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }
  end

  factory :dinghy_dock_storage_pass, class: 'DinghyDockStoragePass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('D', n, n_width: 4) }
    beach_number { 4 }
  end

  factory :utility_cart_pass, class: 'UtilityCartPass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('U', n, n_width: 4) }
    description { 'TEST CART' }
  end

  factory :vehicle_parking_pass, class: 'VehicleParkingPass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('P', n, n_width: 4) }
    state_code { 'MD' }
    tag_number { Faker::Vehicle.license_plate(state_abbreviation: state_code) }
  end

  factory :watercraft_storage_pass, class: 'WatercraftStoragePass' do
    amenity_pass_base
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year('W', n, n_width: 4) }
    beach_number { rand(1..4) }
    location { rand(1..22) }
  end
end
