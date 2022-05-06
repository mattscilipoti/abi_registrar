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
    # Reminder: first_name, email_address are encrypted
    against: searchable_columns,
    associated_against: {
      lots: Lot.searchable_columns,
      residents: Resident.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.all? {|lot| lot.paid_on? }
  end

  def lot_numbers
    # Use leading zeros to create a "natural" sort
    lots.pluck(:lot_number).sort_by{|l| format('%010s' % l)}.join(', ')
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
