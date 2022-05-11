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
    # Reminder: first_name, email_address are encrypted
    against: searchable_columns,
    associated_against: {
      resident: Resident.searchable_columns,
      properties: Property.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  validates_presence_of :tag_number, :sticker_number

  def resident_paid_lot_fees
    unless resident.lot_fees_paid?
      errors.add(:resident, "must pay lot fees")
    end
  end
end
