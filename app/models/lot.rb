class Lot < ApplicationRecord
  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:lot_number, :section]
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

  validates :section, numericality: { allow_nil: true, only_integer: true, in: 1..5 }
  validates :size, inclusion: { in: [0.5, 1], allow_nil: true }

  delegate :street_address, to: :property, allow_nil: true

  def lot_fee_paid?
    paid_on?
  end
  alias_method :paid?, :lot_fee_paid? # alias, original

  def summary
    [lot_number, property].join(', ')
  end
end
