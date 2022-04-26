class Purchase < ApplicationRecord
  belongs_to :residency
  has_one :resident, through: :residency
  has_one :property, through: :residency
  
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
