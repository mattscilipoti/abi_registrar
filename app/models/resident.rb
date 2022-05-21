class Resident < ApplicationRecord
  include Commentable

  # Configure search
  include PgSearch::Model
  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:last_name]
  end
  pg_search_scope :search_by_all,
    # Reminder: first_name, email_address are encrypted
    against: searchable_columns,
    associated_against: {
      properties: Property.searchable_columns,
      lots: Lot.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  encrypts :email_address, deterministic: true
  encrypts :first_name, deterministic: true

  has_many :residencies
  accepts_nested_attributes_for :residencies, reject_if: :all_blank, allow_destroy: true
  has_many :properties, through: :residencies
  has_many :lots, through: :properties

  scope :lot_fees_not_paid, -> {
    distinct.joins(:properties).merge(Property.lot_fees_not_paid)
  }
  scope :lot_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns those where ALL lot fees are paid
    where.not(id: lot_fees_not_paid)
  }

  scope :not_verified, -> { distinct.joins(:residencies).merge(Residency.not_verified) }
  scope :verified, -> { distinct.joins(:residencies).merge(Residency.verified) }
  scope :without_email, -> { distinct.where(email_address: nil) }
  scope :without_first_name, -> { distinct.where(first_name: nil) }
  
  scope :not_paid, -> { lot_fees_not_paid }
  scope :problematic, -> { not_verified.or(without_first_name).or(without_email) }

  validates :last_name, presence: true

  def self.scopes
    %i[
      lot_fees_paid
      lot_fees_not_paid
      verified
      not_verified
      without_email
      without_first_name
    ]
  end

  def inspect
    [id, to_s]
  end

  def full_name
    name = last_name
    name += ", #{first_name}" if first_name.present?
    name += " #{middle_name}" if middle_name.present?
    name
  end

  def lot_fees_paid?
    lots.lot_fees_paid.size == lots.size
  end

  def property_count
    properties.size
  end

  def share_count
    residencies.all.sum(&:share_count)
  end

  def to_s
    "#{full_name} (#{email_address})"
  end

  def verified?
    residencies.any?(&:verified?)
  end
end
