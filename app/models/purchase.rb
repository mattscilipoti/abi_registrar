class Purchase < ApplicationRecord
  belongs_to :resident

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
