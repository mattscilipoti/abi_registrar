class Property < ApplicationRecord
  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies
  has_many :purchase_shares, through: :residencies

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
  end

  def recalculate_share_count
    update share_count: purchase_shares.sum(:quantity)
  end

  def street_address
    [street_number, street_name].join(' ')
  end

  def to_s
    street_address
  end
end
