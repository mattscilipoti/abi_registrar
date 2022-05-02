class Property < ApplicationRecord
  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies
  has_many :share_transactions, through: :residencies
  
  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
  end

  def share_count
    residencies.all.sum(&:share_count)
  end

  def street_address
    [street_number, street_name].join(' ')
  end

  def to_s
    street_address
  end
end
