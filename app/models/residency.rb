class Residency < ApplicationRecord
  belongs_to :property
  belongs_to :resident
  has_many :lots, through: :property
  has_many :share_transactions
  has_many :share_purchases, class_name: 'ShareTransaction', foreign_key: 'residency_id'
  has_many :share_transfers_from, class_name: 'ShareTransaction', foreign_key: 'from_residency_id'
  delegate :lot_fees_paid?, :street_address, to: :property
  delegate :full_name, :email_address, :is_minor?, :phone, to: :resident
  enum :resident_status, {
    owner: 'Owner',
    coowner: 'Co-owner',
    dependent: 'Dependent',
    renter: 'Renter'
  }, scopes: true

  scope :by_property, -> {
    includes(:property).order('properties.street_name', 'properties.street_number')
  }

  scope :lot_fees_not_paid, -> {
    where.not(id: lot_fees_paid)
  }
  scope :lot_fees_paid, -> {
    distinct.joins(:property).merge(Property.lot_fees_paid)
  }

  scope :deed_holder, -> { owner.or(coowner) }
  scope :not_verified, -> { where(verified_on: nil) }
  scope :primary_residence, -> { where(primary_residence: true) }
  scope :verified, -> { where.not(id: not_verified) }
  scope :without_resident_status, -> { where(resident_status: nil) }

  validates :primary_residence, uniqueness: {
    if: -> { primary_residence? },
    scope: :resident_id,
    message: "- there can only be one Primary Residence for each Resident"
  }

  validates :resident_status, uniqueness: {
    if: -> { owner? },
    scope: :property_id,
    message: "- there can only be one Owner for each Property"
  }

  def self.scopes
    %i[
      lot_fees_paid
      lot_fees_not_paid
      verified
      not_verified
    ]
  end

  def deed_holder?
    owner? || coowner?
  end

  def inspect
    {id: id, summary: to_s}
  end

  def share_count
    share_purchases.sum(:quantity) - share_transfers_from.sum(:quantity)
  end

  def to_s
    property_info = property.to_s
    property_info += ' (2nd Home)' unless primary_residence?

    info = []
    info << property_info
    info << resident.to_s
    info << resident_status
    info.compact.join(", ")
  end

  def verified?
    verified_on?
  end
end
