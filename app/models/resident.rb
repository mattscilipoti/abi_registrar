class Resident < ApplicationRecord
  include Commentable

  encrypts :email_address, deterministic: true
  # encrypts :first_name, deterministic: true if minor?

  has_many :amenity_passes, dependent: :destroy
  has_many :residencies, dependent: :destroy
  accepts_nested_attributes_for :residencies, reject_if: :all_blank, allow_destroy: true
  has_many :properties, through: :residencies
  has_many :lots, through: :properties
  has_one :primary_residency, -> { where(primary_residence: true) }, class_name: 'Residency'
  has_one :primary_residence, through: :primary_residency, source: :property

  scope :border, -> { distinct.joins(:residencies).merge(Residency.border) }
  scope :deed_holder, -> { distinct.joins(:residencies).merge(Residency.deed_holder) }
  scope :dependent, -> { distinct.joins(:residencies).merge(Residency.dependent) }
  scope :not_deed_holder, -> { where.not(id: deed_holder) }
  scope :lot_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns those where ALL lot fees are paid
    where.not(id: lot_fees_not_paid)
  }
  scope :lot_fees_not_paid, -> {
    distinct.joins(:properties).merge(Property.lot_fees_not_paid)
  }
  scope :mandatory_fees_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns those where ALL lot fees are paid
    where.not(id: lot_fees_not_paid).where.not(id: user_fee_not_paid)
  }
  scope :mandatory_fees_not_paid, -> {
    distinct.joins(:properties).merge(Property.user_fee_not_paid)
  }
  scope :user_fee_paid, -> {
    # basic "joins" to property returns resident where ANY lots fees are paid,
    #   this returns those where ALL lot fees are paid
    where.not(id: user_fee_not_paid)
  }
  scope :user_fee_not_paid, -> {
    distinct.joins(:properties).merge(Property.user_fee_not_paid)
  }
  scope :renter, -> { distinct.joins(:residencies).merge(Residency.renter) }
  scope :significant_other, -> { distinct.joins(:residencies).merge(Residency.significant_other) }
  scope :not_verified, -> { distinct.joins(:residencies).merge(Residency.not_verified) }
  scope :verified, -> { distinct.joins(:residencies).merge(Residency.verified) }
  scope :with_mailing_address, -> { distinct.where.not(mailing_address: nil) }
  scope :without_mailing_address, -> { distinct.where(mailing_address: nil) }
  scope :without_email, -> { distinct.where(email_address: nil) }
  scope :without_first_name, -> { distinct.where(first_name: nil) }
  scope :without_primary_residence, -> { distinct.joins(:residencies).merge(Residency.without_primary_residence) }
  scope :without_resident_status, -> { distinct.joins(:residencies).merge(Residency.without_resident_status) }

  scope :not_paid, -> { lot_fees_not_paid }
  scope :problematic, -> { not_verified.or(without_first_name).or(without_email) }

  validates :phone, format: { with: /\A[0-9]+\z/, message: "only allows numbers" }, allow_nil: true
  validates :last_name, presence: true

  def self.configure_pgsearch
    # List of searchable columns for this Model
    # ! this must be declared before pg_search_scope
    def self.searchable_columns
      [:last_name, :first_name]
    end
    # Configure pgsearch
    include PgSearch::Model
    pg_search_scope(:search_by_all,
      # Reminder: first_name, email_address are encrypted
      against: searchable_columns,
      associated_against: {
        properties: Property.searchable_columns,
        lots: Lot.searchable_columns
      },
      using: {
        tsearch: { prefix: true }
      }
    )
    pg_search_scope(:search_by_name,
      # Reminder: first_name, email_address are encrypted
      against: [:last_name, :first_name, :middle_name],
      using: {
        tsearch: {
          prefix: true,
          dictionary: "english"
        }
      }
    )
    pg_search_scope(:search_by_name_sounds_like,
      # Reminder: first_name, email_address are encrypted
      against: [:last_name, :first_name, :middle_name],
      using: :dmetaphone
    )
  end.tap { configure_pgsearch } # this syntax ensures the running of the configuration happens after the config and is not separate from the config

  def self.scopes
    %i[
      deed_holder
      not_deed_holder
      border
      dependent
      renter
      significant_other
      without_resident_status
      without_primary_residence
      mandatory_fees_paid
      mandatory_fees_not_paid
      verified
      not_verified
      with_mailing_address
      without_mailing_address
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
    properties.all? {|p| p.lot_fees_paid? }
  end

  def mandatory_fees_paid?
    properties.all? {|p| p.mandatory_fees_paid? }
  end

  def phone=(value)
    if value.present?
      # remove all formatting, leave only numbers
      value = value.to_s.gsub(/\D/, '')
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

  def user_fee_paid?
    return false if properties.count == 0

    properties.all? {|p| p.user_fee_paid_on? }
  end

  def verified?
    residencies.any?(&:verified?)
  end
end
