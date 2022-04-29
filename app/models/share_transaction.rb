class ShareTransaction < ItemTransaction
  after_initialize :set_defaults
  after_create :increment_property_shares
  # TODO: what is maximum? Percentage of total share count?
  validates :quantity, numericality: { only_integer: true, in: 1..100 }
  # TODO: how to calculate shares after update?, delete?
  validate :validate_purchaser_is_deed_holder

  protected
  def set_defaults
    # if a non-default status has been assigned, it will remain
    # if no value has been assigned, the reader will return the default and assign it
    # this keeps the default logic DRY
    self.cost_per = 50.00 if cost_per.zero?
  end

  def increment_property_shares
    property.recalculate_share_count
  end

  def validate_purchaser_is_deed_holder
    errors.add(:residency, 'must be a Deed Holder') unless residency && residency.deed_holder?  
  end

end