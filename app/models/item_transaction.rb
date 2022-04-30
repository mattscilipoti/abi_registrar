class ItemTransaction < ApplicationRecord
  enum :transaction_type, { purchase: 0, transfer: 1 }
  belongs_to :residency
  belongs_to :from_residency, class_name: 'Residency', optional: true
  has_one :resident, through: :residency
  has_one :property, through: :residency

  validates :residency, presence: true
  validate :requested_transfer_quantity_is_available
  
  def cost_per=(value)
    super
    calculate_cost_total
  end

  def quantity=(value)
    super
    calculate_cost_total
  end

  def calculate_cost_total
    self.cost_total = cost_per.to_f * quantity.to_i
  end

  private

  def requested_transfer_quantity_is_available
    raise NotImplementedError, "must be implementd in STI child class"
  end
end
