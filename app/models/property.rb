class Property < ApplicationRecord
  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
  end
  
  def street_address
    [street_number, street_name].join(' ')
  end
end
