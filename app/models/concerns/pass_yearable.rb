# frozen_string_literal: true

module PassYearable
  extend ActiveSupport::Concern

  included do
    # Accepts a year parameter which can be:
    # - an integer or numeric string (e.g. 2024 or '2024') -> filters by that year
    # - the string 'all' -> returns all records (including those with nil season_year)
    # - nil or blank -> treated as current year
    scope :by_year, ->(year) do
      # Normalize input and decide which branch to take.
      # Accepts Integer, numeric string (e.g. '2024'), 'all', or nil/blank.
      y = year
      # If it's a string, sanitize whitespace and lowercase for comparison
      y = y.to_s.strip.downcase if y.respond_to?(:to_s)

      if y == 'all'
        all
      elsif y == 'none'
        where(season_year: nil)
      elsif y.blank?
        where(season_year: AppSetting.current_season_year)
      elsif y.to_s.match?(/\A\d+\z/)
        where(season_year: y.to_i)
      else
        # Non-numeric unexpected values default to configured current season
        # year for safety.
        where(season_year: AppSetting.current_season_year)
      end
    end

    # Set a sensible default for new records: use the configured current season year
    # unless a season_year was explicitly provided. This ensures forms and new
    # records default to the expected season without requiring controller changes.
    after_initialize do
      # Only set for new records and when the attribute exists and is nil/blank.
      if new_record? && respond_to?(:season_year) && season_year.blank?
        self.season_year = AppSetting.current_season_year
      end
    end
  end
end
