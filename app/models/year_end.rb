class YearEnd
  def self.reset_fees
    reset_amenities_processed
    reset_lot_fees
    reset_user_fees
    increment_season_year
  end

  def self.reset_amenities_processed
    Property.update_all(amenities_processed: nil)
  end

  def self.reset_lot_fees
    Lot.update_all(paid_on: nil)
    Property.update_all(lot_fees_paid_on: nil)
  end

  def self.reset_user_fees
    Property.update_all(user_fee_paid_on: nil)
  end

  # Increment the season_year for amenity passes that are for the current
  # season. This moves current-year passes to the next season so the UI and
  # filters reflect the new season after year-end processing.
  #
  # Behaviour / assumptions:
  # - Only increments records where season_year == Time.zone.now.year.
  # - Leaves nil or historical season_year values untouched.
  def self.increment_season_year
    current = AppSetting.current_season_year

    # Bump the configured default season year so filters and helpers
    # that rely on `AppSetting.current_season_year` move to the next year.
    # Store as a string to match AppSetting's simple key/value storage.
    AppSetting.set('current_season_year', (current + 1).to_s)
  end
end
