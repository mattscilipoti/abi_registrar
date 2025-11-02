# frozen_string_literal: true

# Simple key/value settings stored in the database. This is intentionally
# minimal — it's not a full-featured settings store, but it provides a
# persistent place to store the current season year.
class AppSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  # Ensure cache invalidation for current season year happens for any AR
  # write path (create/update/destroy). This complements the explicit
  # invalidation in `AppSetting.set` (defense in depth).
  after_commit :invalidate_season_cache, on: %i[create update destroy]

  # Cache key and TTL dedicated to the "season year" setting.
  SEASON_YEAR_CACHE_KEY = 'app_setting/current_season_year'.freeze
  # Use a long TTL as a safety net; cache is explicitly invalidated on writes.
  SEASON_YEAR_CACHE_EXPIRES_IN = 30.days

  # Get the string value for a key, or nil if missing
  def self.get(key)
    record = find_by(key: key.to_s)
    record&.value
  end

  # Set the string value for a key (creates or updates)
  def self.set(key, value)
    rec = find_or_initialize_by(key: key.to_s)
    rec.value = value
    rec.save!
    # Call the centralized invalidation helper so all invalidation logic
    # stays in one place (reduces duplication between callers).
    invalidate_season_cache_for(rec.key)

    rec
  end

  private

  # Instance wrapper that forwards to the class-level invalidation helper.
  def invalidate_season_cache(key = self.key)
    self.class.invalidate_season_cache_for(key, previous_changes['key'])
  end

  # Centralized invalidation logic. Accepts the current key and an optional
  # previous key-change array (from `previous_changes['key']`) so callers can
  # provide rename information when available. This keeps the deletion logic
  # in one place and avoids duplicated conditionals.
  def self.invalidate_season_cache_for(key, previous_key_changes = nil)
    if key.to_s == 'current_season_year' || (previous_key_changes && previous_key_changes.include?('current_season_year'))
      Rails.cache.delete(SEASON_YEAR_CACHE_KEY)
    end
  end

  # Returns the configured current season year as an Integer.
  # Priority: DB-stored setting with key 'current_season_year', otherwise
  # fall back to the system year (Time.zone.now.year).
  def self.current_season_year
    # Use Rails.cache for caching the rarely-changing season year. The cache
    # will be explicitly invalidated when `AppSetting.set` is called.
    Rails.cache.fetch(SEASON_YEAR_CACHE_KEY, expires_in: SEASON_YEAR_CACHE_EXPIRES_IN) do
      begin
        val = get('current_season_year')
        return val.to_i if val.present? && val.to_s.match?(/\A\d+\z/)
      rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
        # If the DB/table isn't available yet (e.g., during setup/migrations),
        # fall back to the system year rather than raising.
      end

      Time.zone.now.year
    end
  end
end
