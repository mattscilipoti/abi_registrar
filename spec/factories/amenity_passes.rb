require_relative 'factory_helpers'

FactoryBot.define do
  LOREM_IPSUM = 'Lorem ipsum dolor sit amet' #, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
  # Shared trait for amenity pass attributes and callbacks
  trait :amenity_pass_base do
    description { LOREM_IPSUM }
    resident
    # season_year: see after(:build)

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    after(:build) do |pass, _evaluator|
      FactoryHelpers.ensure_property_with_mandatory_fees(pass.resident)
      # If season_year wasn't explicitly provided, try to parse it from the
      # sticker_number. We expect sticker_number to contain a two-digit year
      # as the first numeric run (e.g. "25" -> 2025). Only set when the
      # guessed year is inside a sensible range. Tests that require an
      # explicit nil can set `season_year = nil` after building the factory.
      if pass.season_year.nil?
        if pass.sticker_number.blank?
          pass.season_year = AppSetting.current_season_year
        else
          guessed = AmenityPass.guess_season_year_from_sticker(pass.sticker_number)
          pass.season_year = guessed if guessed
        end
      end
    end
  end

  factory :beach_pass, class: 'BeachPass' do
    amenity_pass_base
    # Beach passes should not have a letter or hyphen prefix; pass nil so the
    # helper returns just the two-digit year plus the zero-padded number.
    sequence(:sticker_number) { |n| FactoryHelpers.sticker_with_year(nil, n, n_width: 4) }
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
