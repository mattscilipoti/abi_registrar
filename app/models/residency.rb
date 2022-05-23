class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  has_many :lots, through: :property
  has_many :share_transactions
  has_many :share_purchases, class_name: 'ShareTransaction', foreign_key: 'residency_id'
  has_many :share_transfers_from, class_name: 'ShareTransaction', foreign_key: 'from_residency_id'
  delegate :lot_fees_paid?, :street_address, to: :property
  delegate :full_name, :email_address, :is_minor, :phone, to: :resident
  enum :resident_status, { deed_holder: 'Deed Holder', dependent: 'Dependent', renter: 'Renter' }, scopes: true

  scope :lot_fees_not_paid, -> {
    distinct.joins(:property).merge(Property.lot_fees_not_paid)
  }
  scope :lot_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns only those where ALL lot fees are paid
    where.not(id: lot_fees_not_paid)
  }

  scope :not_verified, -> { where(verified_on: nil) }
  scope :verified, -> { where.not(id: not_verified) }

  def self.scopes
    %i[
      lot_fees_paid
      lot_fees_not_paid
      verified
      not_verified
    ]
  end

  def inspect
    {id: id, summary: to_s}
  end

  def resident_status_i18n
    resident_status && resident_status.gsub('_', ' ').titleize
  end

  def share_count
    share_purchases.sum(:quantity) - share_transfers_from.sum(:quantity)
  end

  def to_s
    [resident.to_s, resident_status_i18n, property.to_s].compact.join(", ")
  end

  def verified?
    verified_on?
  end
end
