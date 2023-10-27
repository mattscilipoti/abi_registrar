class YearEnd
  def self.reset_fees
    reset_amenities_processed
    reset_lot_fees
  end

  def self.reset_amenities_processed
    Property.update_all(amenities_processed: nil)
  end

  def self.reset_lot_fees
    Lot.update_all(paid_on: nil)
  end
end
