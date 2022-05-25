require "address_composer"

class Property < ApplicationRecord
  include Commentable

  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies
  has_many :share_transactions, through: :residencies

  delegate :section, to: :default_lot, allow_nil: true

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

  scope :deed_holder, -> { distinct.joins(:residencies).merge(Residency.deed_holder) }
  scope :lot_fees_not_paid, -> { distinct.where.not(id: lot_fees_paid) }
  scope :lot_fees_paid, -> { distinct.joins(:lots).merge(Lot.fee_paid) }
  scope :not_paid, -> { lot_fees_not_paid }
  scope :owner, -> { distinct.joins(:residencies).merge(Residency.owner) }
  scope :problematic, -> { without_lot.or(without_street_info) }
  scope :without_lot, -> { joins(:lots).where(lots: nil) }
  scope :without_street_info, -> { where(street_number: nil).or(where(street_name: nil)) }

  def self.scopes
    %i[
      lot_fees_paid
      lot_fees_not_paid
      without_lot
      without_street_info
    ]
  end

  def default_lot
    lots.first
  end

  def inspect
    [id, to_s]
  end

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lots.lot_fees_paid.size == lots.size
  end

  def mailing_address(resident: owner)
    address_components = {
      "house_number" => street_number,
      "road" => street_name.upcase,
      "city" => "CROWNSVILLE",
      "postcode" => 31032,
      "county" => "Anne Arundel",
      "state" => "Maryland",
      "country_code" => "US"
    }

    mailing_address = AddressComposer.compose(address_components)

    recipient = resident.try(:full_name)
    mailing_address.prepend "#{recipient.upcase}\n" if recipient

    mailing_address
  end

  def owner
    residencies.owner.present? && residencies.owner.first.resident
  end

  def share_count
    residencies.all.sum(&:share_count)
  end

  def street_address
    [street_number || '⁇', street_name || '⁇'].join(' ')
  end

  def to_s
    street_address
  end

  private

  def there_can_be_only_one_owner
    errors.add(:residencies, "there can only be ONE... owner") if residencies.owner.count > 1
  end
end
