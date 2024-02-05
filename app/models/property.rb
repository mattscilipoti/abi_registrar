require "address_composer"

class Property < ApplicationRecord
  include Commentable
  alias_attribute :tax_id, :tax_identifier # alias, original
  validate :confirm_processing_amenities_is_allowed

  has_many :lots
  has_many :residencies
  has_many :residents, through: :residencies
  has_many :amenity_passes, through: :residents
  has_many :share_transactions, through: :residencies

  scope :amenities_processed, -> { where.not(amenities_processed: nil) }
  scope :membership_eligible, -> { where(membership_eligible: true) }
  scope :not_membership_eligible, -> { where(membership_eligible: false) }
  scope :deed_holder, -> { distinct.joins(:residencies).merge(Residency.deed_holder) }
  scope :for_sale, -> { where(for_sale: true) }
  scope :not_for_sale, -> { where.not(for_sale: true).or(where(for_sale: nil)) }
  scope :lot_fees_not_paid, -> { where(lot_fees_paid_on: nil) }
  scope :mandatory_fees_paid, -> { where.not(lot_fees_paid_on: nil, user_fee_paid_on: nil) }
  scope :mandatory_fees_not_paid, -> { where(lot_fees_paid_on: nil).where(user_fee_paid_on: nil) }
  scope :lot_fees_paid, -> { where.not(lot_fees_paid_on: nil) }
  scope :not_paid, -> { lot_fees_not_paid }
  scope :owner, -> { distinct.joins(:residencies).merge(Residency.owner) }
  scope :problematic, -> { without_lot.or(without_section).or(without_street_info) }
  scope :test, -> { where("street_name LIKE '%TEST%'") }
  scope :not_test, -> { where.not(id: test) }
  scope :user_fee_not_paid, -> { where(user_fee_paid_on: nil) }
  scope :user_fee_paid, -> { where.not(user_fee_paid_on: nil) }
  scope :without_lot, -> { where.missing(:lots) }
  scope :without_section, -> { where(section: nil) }
  scope :without_street_info, -> { where(street_number: nil).or(where(street_name: nil)) }

  validates :section, numericality: { allow_nil: true, only_integer: true, in: 1..5 }
  validates :tax_identifier, presence: true, format: { with: /\A\d{2}\s\d{3}\s\d{8}\Z/ } # describes format provided by SDAT

  def self.configure_pgsearch
    # List of searchable columns for this Model
    # ! this must be declared before pg_search_scope
    def self.searchable_columns
      [
        :street_name,
        :street_number,
        :tax_identifier,
      ]
    end
    # Configure pgsearch
    include PgSearch::Model
    pg_search_scope(:search_by_all,
      against: searchable_columns,
      associated_against: {
        lots: Lot.searchable_columns,
        residents: Resident.searchable_columns
      },
      using: {
        tsearch: { prefix: true }
      }
    )
    pg_search_scope(:search_by_address,
      against: [:street_number, :street_name]
      # using: {
      #   tsearch: { prefix: true }
      # }
    )
  end.tap { configure_pgsearch } # this syntax ensures the running of the configuration happens after the config and is not separate from the config

  def self.scopes
    %i[
      membership_eligible
      not_membership_eligible
      mandatory_fees_paid
      mandatory_fees_not_paid
      for_sale
      without_lot
      without_section
      without_street_info
    ]
  end

  def self.subdivisions
    {
      sunrise_beach: '748',
      arden_on_the_severn: '004',
    }
  end

  # account_number portion of tax_id
  def account_number(tax_id = self.tax_id)
    tax_id[7..14]
  end

  def confirm_processing_amenities_is_allowed
    if amenities_processed.present? and ! mandatory_fees_paid?
      errors.add(:amenities_processed, "requires mandatory fees to be paid")
    end
  end

  def default_lot
    lots.first
  end

  # district portion of tax_id
  def district(tax_id = self.tax_id)
    tax_id[0..1]
  end

  def inspect
    [id, to_s]
  end

  def lot_count
    lots.size
  end

  def lot_fees_paid?
    lot_fees_paid_on?
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

  def mandatory_fees_paid?
    user_fee_paid_on? && lot_fees_paid?
  end

  # Lists tax_ids that are not in Sunrise Beach subdivision, but are part of ABI
  def membership_eligible_exceptions
    [
      '02 004 90049492', # 1007 Omar Dr (Arden on the Severn)
      '02 004 05254975', # 1030 Omar Dr (Arden on the Severn)
      '02 000 90050935', # 920 Waterview Dr (Sunrise Beach)
      '02 000 90050936', # 1035 Miller Cir (Sunrise Beach)
    ]
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

  # subdivision portion of tax_id
  def subdivision(tax_id = self.tax_id)
    tax_id[3..5]
  end

  # Indicates if this lot's subdivision is Sunrise Beach
  def subdivision_is_sunrise_beach?
    district == '002' && subdivision == Lot.subdivisions.fetch(:sunrise_beach)
  end
  alias_method :sunrise_beach?, :subdivision_is_sunrise_beach? # alias, original

  def to_s
    street_address
  end
end
