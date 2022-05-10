class Lot < ApplicationRecord
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
  class << self
    # support "interface" of other classes
    alias lot_fees_not_paid fee_not_paid
    alias lot_fees_paid fee_paid
  end

  validates :district, numericality: { only_integer: true }
  validates :subdivision, numericality: { only_integer: true }
  validates :account_number, numericality: { only_integer: true }
  validates :section, numericality: { only_integer: true, in: 1..5 }
  validates :size, inclusion: { in: [0.5, 1] }

  delegate :street_address, to: :property

  def summary
    [lot_number, property].join(', ')
  end

  def tax_identifier
    formatted_district = format('%02d', district)
    [formatted_district, subdivision, account_number].join(' ')
  end
end
