class Lot < ApplicationRecord

  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:district, :subdivision, :account_number, :lot_number, :section]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: searchable_columns,
    associated_against: {
      property: Property.searchable_columns,
      residents: Resident.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  belongs_to :property, optional: true
  has_many :residencies, through: :property
  has_many :residents, through: :residencies

  scope :fee_not_paid, -> { where(paid_on: nil) }
  scope :fee_paid, -> { where.not(paid_on: nil) }
  scope :not_paid, -> { fee_not_paid }
  scope :problematic, -> { without_property.or(without_lot_number).or(without_section) }
  scope :without_lot_number, -> { where(lot_number: nil) }
  scope :without_property, -> { where(property_id: nil) }
  scope :without_section, -> { where(section: nil) }

  class << self
    # support "interface" of other classes
    alias lot_fees_not_paid fee_not_paid
    alias lot_fees_paid fee_paid
  end

  def self.scopes
    %i[
      fee_paid
      fee_not_paid
      without_lot_number
      without_property
      without_section
    ]
  end

  validates :district, numericality: { only_integer: true }
  validates :subdivision, numericality: { only_integer: true }
  validates :account_number, numericality: { only_integer: true }
  validates :section, numericality: { allow_nil: true, only_integer: true, in: 1..5 }
  validates :size, inclusion: { in: [0.5, 1], allow_nil: true }

  delegate :street_address, to: :property, allow_nil: true

  # Indicates if the lot is a part fo ABI
  def abi?
    subdivision_is_sunrise_beach? || abi_exceptions.include?(tax_identifier)
  end

  # Lists tax_ids that are not in Sunrise Beach subdivision, but are part of ABI
  def abi_exceptions
    [
      '02 004 90049492', # 1007 Omar Dr (Hejl, Jan)
      '02 004 05254975' # 1030 Omar Dr (Brown, Michael)
    ]
  end

  def lot_fee_paid?
    paid_on?
  end
  alias_method :paid?, :lot_fee_paid? # alias, original

  # Indicates if this lot's subdivision is Sunrise Beach
  def subdivision_is_sunrise_beach?
    district == 2 && subdivision == 748
  end
  alias_method :sunrise_beach?, :subdivision_is_sunrise_beach? # alias, original

  def summary
    [lot_number, property].join(', ')
  end

  def tax_identifier
    formatted_district = format('%02d', district)
    formatted_subdivision = format('%03d', subdivision)
    formatted_account_number = format('%08d', account_number)
    [formatted_district, formatted_subdivision, formatted_account_number].join(' ')
  end
  alias_method :tax_id, :tax_identifier # alias, original
end
