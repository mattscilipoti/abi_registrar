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
      elsif y.blank?
        where(season_year: Time.zone.now.year)
      elsif y.to_s.match?(/\A\d+\z/)
        where(season_year: y.to_i)
      else
        # Non-numeric unexpected values default to current year for safety.
        where(season_year: Time.zone.now.year)
      end
    end
  end
end
