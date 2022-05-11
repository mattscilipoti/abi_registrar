class Property < ApplicationRecord
  include Commentable

  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies
  has_many :share_transactions, through: :residencies

  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:street_number, :street_name]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: searchable_columns,
    associated_against: {
      lots: Lot.searchable_columns,
      residents: Resident.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  scope :lot_fees_paid, -> { distinct.joins(:lots).merge(Lot.fee_paid) }
  scope :lot_fees_not_paid, -> { distinct.joins(:lots).merge(Lot.fee_not_paid) }

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
  end

  def share_count
    residencies.all.sum(&:share_count)
  end

  def street_address
    [street_number, street_name].join(' ')
  end

  def to_s
    street_address
  end
end
