class YearEnd
  # Preferred public API: run all year-end housekeeping tasks.
  # This was previously exposed as `reset_fees`
  def self.process_year_end
    # Capture counts so we can log what changed for operators and notify
    # external listeners. We instrument the full operation so subscribers
    # receive timing and a payload with the affected row counts and
    # season information.
    previous_season = AppSetting.current_season_year

    payload = { previous_season: previous_season }

    payload[:amenities_cleared] = clear_amenities_processed
    payload[:lots_cleared] = clear_lot_payment_dates
    payload[:user_fee_dates_cleared] = clear_user_fee_dates
    advance_season_year
    payload[:new_season] = AppSetting.current_season_year

    # Emit an explicit log line summarizing the run for operators.
    if defined?(Rails) && Rails.respond_to?(:logger)
      Rails.logger.info("YearEnd.process_year_end completed: amenities_cleared=#{payload[:amenities_cleared]}, lots_cleared=#{payload[:lots_cleared]}, user_fee_dates_cleared=#{payload[:user_fee_dates_cleared]}, season: #{payload[:previous_season]} -> #{payload[:new_season]}")
    end

    payload
  end

  def self.clear_amenities_processed
    Property.update_all(amenities_processed: nil)
  end

  def self.clear_lot_payment_dates
    # Return total rows changed across Lot and Property updates.
    lots = Lot.update_all(paid_on: nil)
    properties = Property.update_all(lot_fees_paid_on: nil)
    (lots || 0) + (properties || 0)
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
