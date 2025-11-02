# frozen_string_literal: true

# Simple key/value settings stored in the database. This is intentionally
# minimal — it's not a full-featured settings store, but it provides a
# persistent place to store the current season year.
class AppSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

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
    rec
  end

  # Returns the configured current season year as an Integer.
  # Priority: DB-stored setting with key 'current_season_year', otherwise
  # fall back to the system year (Time.zone.now.year).
  def self.current_season_year
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
