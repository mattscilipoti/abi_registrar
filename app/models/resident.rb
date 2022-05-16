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

  encrypts :age_of_minor
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
    #   this returns ab=ny where ALL lot fees are paid
    where.not(id: lot_fees_not_paid)
  }

  validates :age_of_minor, numericality: { integer: true, greater_than: 0, less_than: 21, allow_blank: true }
  validates :last_name, presence: true


  def full_name
    name = last_name
    name += ", #{first_name}" if first_name.present?
    name += " #{middle_name}" if middle_name.present?
    name
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
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
end
