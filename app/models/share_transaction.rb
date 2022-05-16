class ShareTransaction < ItemTransaction
  after_initialize :set_defaults
  # TODO: what is maximum? Percentage of total share count?
  validates :quantity, numericality: { only_integer: true, in: 1..100 }
  # TODO: how to calculate shares after update?, delete?
  validate :validate_purchaser_is_deed_holder

  protected
  def default_cost_per_share
    case activity
    when :purchase, 'purchase'
      50.00
    else
      0
    end
  end
  
  def set_defaults
    # if a non-default status has been assigned, it will remain
    # if no value has been assigned, the reader will return the default and assign it
    # this keeps the default logic DRY
    self.cost_per = default_cost_per_share if cost_per.nil?
  end

  def validate_purchaser_is_deed_holder
    return true if import? # Skip deed_holder validation when importing shares

    errors.add(:residency, 'must be a Deed Holder') unless residency && residency.deed_holder?  
  end

  private

  def requested_transfer_quantity_is_available
    if transfer? && quantity > from_residency.share_count
      errors.add(:quantity, "must be less than or equal to owned shares: #{from_residency.share_count}")
    end
  end

end