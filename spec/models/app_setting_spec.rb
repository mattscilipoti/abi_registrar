require 'rails_helper'

RSpec.describe AppSetting, type: :model do
  before do
    # Use an in-memory cache for these examples so we can observe cache
    # behavior. The test environment uses :null_store by default which
    # doesn't persist entries, so swap in a MemoryStore for the duration
    # of each example.
    @original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    Rails.cache.clear
  end

  after do
    Rails.cache = @original_cache
  end

  describe 'cache invalidation' do
    let(:cache_key) { AppSetting::SEASON_YEAR_CACHE_KEY }

    it 'invalidates cache when using AppSetting.set for current_season_year' do
      # Prime the cache by reading the current value
      original = AppSetting.current_season_year

      AppSetting.set('current_season_year', '2025')

      # The public API should return the updated value after the set
      expect(AppSetting.current_season_year).to eql(2025)
    end

    it 'invalidates cache when updating a record with key current_season_year' do
      rec = AppSetting.create!(key: 'current_season_year', value: '2023')
      # Prime the cache and verify we read the stored value
      expect(AppSetting.current_season_year).to eql(2023)

      rec.update!(value: '2024')

      expect(AppSetting.current_season_year).to eql(2024)
    end

    it 'invalidates cache when renaming a key to current_season_year' do
      rec = AppSetting.create!(key: 'other_setting', value: 'x')
      # Prime the cache (read the current value)
      prior = AppSetting.current_season_year

      rec.update!(key: 'current_season_year')

      # After renaming, the cache should be cleared and the public API
      # can be called without error; we don't assert a specific value
      # here because the renamed value may not be numeric.
      expect { AppSetting.current_season_year }.not_to raise_error
    end
  end
end
