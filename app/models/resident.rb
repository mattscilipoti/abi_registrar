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
  has_one :primary_residency, -> { where(primary_residence: true) }, class_name: 'Residency'
  has_one :primary_residence, through: :primary_residency, source: :property

  scope :lot_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns those where ALL lot fees are paid
    distinct.where.not(id: lot_fees_not_paid)
  }
  scope :lot_fees_not_paid, -> {
    distinct.joins(:lots).merge(Lot.lot_fees_not_paid)
  }

  scope :not_verified, -> { distinct.joins(:residencies).merge(Residency.not_verified) }
  scope :verified, -> { distinct.joins(:residencies).merge(Residency.verified) }
  scope :without_email, -> { distinct.where(email_address: nil) }
  scope :without_first_name, -> { distinct.where(first_name: nil) }
  scope :without_resident_status, -> { distinct.joins(:residencies).merge(Residency.without_resident_status) }

  scope :not_paid, -> { lot_fees_not_paid }
  scope :problematic, -> { not_verified.or(without_first_name).or(without_email) }

  validates :phone, format: { with: /\A[0-9]+\z/, message: "only allows numbers" }
  validates :last_name, presence: true

  def self.scopes
    %i[
      lot_fees_paid
      lot_fees_not_paid
      verified
      not_verified
      without_email
      without_first_name
      without_resident_status
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

  def phone=(value)
    if value.present?
      # remove all formatting, leave only numbers
      value = value.gsub(/\D/, '')
    end
    super(value)
  end

  def property_count
    properties.size
  end

  def share_count
    residencies.all.sum(&:share_count)
  end

  def to_s
    # "#{full_name} (#{email_address})"
    full_name
  end

  def verified?
    residencies.any?(&:verified?)
  end
end
