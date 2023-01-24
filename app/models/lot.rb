class Lot < ApplicationRecord

  belongs_to :property, optional: true
  has_many :residencies, through: :property
  has_many :residents, through: :residencies

  scope :fee_not_paid, -> { where(paid_on: nil) }
  scope :fee_paid, -> { where.not(paid_on: nil) }
  scope :not_paid, -> { fee_not_paid }
  scope :problematic, -> { without_property.or(without_lot_number) }
  scope :without_lot_number, -> { where(lot_number: nil) }
  scope :without_lot_size, -> { where(size: nil) }
  scope :without_property, -> { where(property_id: nil) }

  class << self
    # support "interface" of other classes
    alias lot_fees_not_paid fee_not_paid
    alias lot_fees_paid fee_paid
  end

  def self.configure_pgsearch
    # List of searchable columns for this Model
    # ! this must be declared before pg_search_scope
    def self.searchable_columns
      [:lot_number]
    end

    # Configure pgsearch
    include PgSearch::Model
    pg_search_scope(:search_by_all,
      against: searchable_columns,
      associated_against: {
        property: Property.searchable_columns,
        residents: Resident.searchable_columns
      },
      using: {
        tsearch: { prefix: true }
      }
    )
  end.tap { configure_pgsearch } # this syntax ensures the running of the configuration happens after the config and is not separate from the config

  def self.scopes
    %i[
      fee_paid
      fee_not_paid
      without_lot_number
      without_lot_size
      without_property
    ]
  end

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
