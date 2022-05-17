class Vehicle < ApplicationRecord
  belongs_to :resident
  has_many :properties, :through => :resident

  validate :resident_paid_lot_fees

  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:tag_number, :sticker_number]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: searchable_columns,
    associated_against: {
      resident: Resident.searchable_columns,
      properties: Property.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  scope :not_paid, -> { all } # TODO: sticker fee not paid?
  scope :problematic, -> { without_tag_number.or(without_sticker_number) }
  scope :without_tag_number, -> { where(tag_number: nil) }
  scope :without_sticker_number, -> { where(sticker_number: nil) }

  validates_presence_of :tag_number, :sticker_number

  def resident_paid_lot_fees
    unless resident.lot_fees_paid?
      errors.add(:resident, "must pay lot fees")
    end
  end
end
