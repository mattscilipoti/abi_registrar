# frozen_string_literal: true

module AmenityPassValidations
  extend ActiveSupport::Concern

  included do
    # Validate season_year is within a sensible range when present.
    #
    # Require presence of season_year on create or any update to an existing record
    # (this allows legacy records with nil season_year to remain unchanged until
    # they are edited).
  validates :season_year, presence: true, if: :require_season_year_on_save?

  # Validate numeric range using the application-configured season bounds.
  validate :season_year_in_configured_range

    # Ensure sticker_number uniqueness across passes
    validates :sticker_number, presence: true, uniqueness: true
  end

  private

  # Return true for new records or any record that is being changed/saved.
  # This enforces presence for created records and for any update operation.
  def require_season_year_on_save?
    new_record? || changed?
  end

  def season_year_in_configured_range
    return if season_year.nil?

    unless season_year.is_a?(Integer)
      errors.add(:season_year, 'must be an integer')
      return
    end

    # The minimum allowed season year is configurable via AppSetting.min_season_year.
    # Use AppSetting.max_season_year for the upper bound so the app can accept
    # next-season values when configured.
    min = AppSetting.min_season_year
    max = AppSetting.max_season_year

    if season_year < min
      errors.add(:season_year, "must be greater than or equal to #{min}")
    elsif season_year > max
      errors.add(:season_year, "must be less than or equal to #{max}")
    end
  end


end
