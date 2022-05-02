class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  has_many :share_transactions
  has_many :share_purchases, class_name: 'ShareTransaction', foreign_key: 'residency_id'
  has_many :share_transfers_from, class_name: 'ShareTransaction', foreign_key: 'from_residency_id'
  delegate :street_address, to: :property
  delegate :full_name, :email_address, to: :resident
  enum :resident_status, { deed_holder: 0, dependent: 1, renter: 2 }, scopes: true

  def share_count
    share_purchases.sum(:quantity) - share_transfers_from.sum(:quantity)
  end

  def to_s
    [resident.to_s, property.to_s].compact.join(", ")
  end
end
