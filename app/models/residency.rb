class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  has_many :share_transactions
  has_many :share_purchases, class_name: 'ShareTransaction', foreign_key: 'residency_id'
  has_many :share_transfers_from, class_name: 'ShareTransaction', foreign_key: 'from_residency_id'
  delegate :street_address, to: :property
  delegate :full_name, :email_address, to: :resident
  enum :resident_status, { deed_holder: 0, dependent: 1, renter: 2 }, scopes: true

  scope :lot_fees_not_paid, -> {
    distinct.joins(:property).merge(Property.lot_fees_not_paid)
  }
  scope :lot_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns ab=ny where ALL lot fees are paid
    where.not(id: lot_fees_not_paid)
  }

  def share_count
    share_purchases.sum(:quantity) - share_transfers_from.sum(:quantity)
  end

  def to_s
    [resident.to_s, property.to_s].compact.join(", ")
  end
end
