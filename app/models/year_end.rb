class YearEnd
  # Preferred public API: run all year-end housekeeping tasks.
  # This was previously exposed as `reset_fees`
  def self.process_year_end
    clear_amenities_processed
    clear_lot_payment_dates
    clear_user_fee_dates
    advance_season_year
  end

  def self.clear_amenities_processed
    Property.update_all(amenities_processed: nil)
  end

  def self.clear_lot_payment_dates
    Lot.update_all(paid_on: nil)
    Property.update_all(lot_fees_paid_on: nil)
  end

  def self.clear_user_fee_dates
    Property.update_all(user_fee_paid_on: nil)
  end

  # Advance the configured season year so filters and helpers that rely on
  # `AppSetting.current_season_year` move to the next year.
  #
  # Behaviour / assumptions:
  # - Only increments the configured default season year value.
  # - Leaves nil or historical season_year values on records untouched.
  def self.advance_season_year
    current = AppSetting.current_season_year

    # Bump the configured default season year and store as a string to
    # match AppSetting's simple key/value storage.
    AppSetting.set('current_season_year', (current + 1).to_s)
  end
end
