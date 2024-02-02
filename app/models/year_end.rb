class YearEnd
  def self.reset_fees
    reset_amenities_processed
    reset_lot_fees
    reset_user_fees
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
end
