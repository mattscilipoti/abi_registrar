class PurchaseShares < Purchase
  after_initialize :set_defaults

  protected
  def set_defaults
    # if a non-default status has been assigned, it will remain
    # if no value has been assigned, the reader will return the default and assign it
    # this keeps the default logic DRY
    self.cost_per ||= 20.00
  end
end