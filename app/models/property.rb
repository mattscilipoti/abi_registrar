class Property < ApplicationRecord
  has_many :lots
  has_many :residencies
  has_many :resdents, through: :residencies

  def lot_count
    lots.size
  end
  
  def street_address
    [street_number, street_name].join(' ')
  end
end
