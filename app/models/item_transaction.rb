class ItemTransaction < ApplicationRecord
  enum :transaction_type, { purchase: 0 }
  belongs_to :residency
  belongs_to :from_residency, class_name: 'Residency', optional: true
  has_one :resident, through: :residency
  has_one :property, through: :residency

  validates :residency, presence: true
  
  def cost_per=(value)
    super
    calculate_cost_total
  end

  def quantity=(value)
    super
    calculate_cost_total
  end

  def calculate_cost_total
    self.cost_total = cost_per * quantity
  end
end
