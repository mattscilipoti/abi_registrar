require 'rails_helper'
require 'rake'

RSpec.describe 'amenity_passes:backfill_season_year rake task' do
  before(:all) do
    # Load rake tasks once for the spec run
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  after(:each) do
    # allow re-invoking the task in multiple examples
    Rake::Task['amenity_passes:backfill_season_year'].reenable
  end

  it 'backfills season_year for BeachPass records with numeric-only sticker numbers' do
    # Use a two-digit year that is guaranteed to be in the allowed range
    current_year = Time.zone.now.year
    target_year = current_year - 1
    yy = (target_year % 100).to_s.rjust(2, '0')

  # Create a beach pass with a numeric-only sticker like "23xxxx".
  # Persist it without validations to simulate an existing legacy record with nil season_year.
  bp = FactoryBot.build(:beach_pass, sticker_number: "#{yy}0001", season_year: nil)
  # The factory's after(:build) hook may populate season_year from the
  # sticker_number. Tests that need an explicit nil must set it after
  # building the factory (see spec/factories/amenity_passes.rb).
  bp.season_year = nil
  bp.save(validate: false)

    expect(bp.season_year).to be_nil

    # Run the rake task (not a dry run)
    Rake::Task['amenity_passes:backfill_season_year'].invoke

    expect(bp.reload.season_year).to eq(target_year)
  end
end
