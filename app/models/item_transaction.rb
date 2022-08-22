class ItemTransaction < ApplicationRecord
  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:type, :activity, :cost_per]
  end
  # Configure search
  include PgSearch::Model
  pg_search_scope :search_by_all,
    against: searchable_columns,
    associated_against: {
      property: Property.searchable_columns,
      resident: Resident.searchable_columns,
      from_resident: Resident.searchable_columns,
      from_property: Property.searchable_columns
    },
    using: {
      tsearch: { prefix: true }
    }

  has_paper_trail
  enum :activity, { purchase: 'Purchase', transfer: 'Transfer', import: 'Import' }
  belongs_to :from_residency, class_name: 'Residency', optional: true
  belongs_to :residency
  has_one :from_resident, through: :from_residency, source: :resident, required: false
  has_one :from_property, through: :from_residency, source: :property, required: false
  has_one :resident, through: :residency
  has_one :property, through: :residency

  scope :in_the_future, -> { where('transacted_at >= ?', Time.now) }
  scope :large_quantity, -> { where('quantity > ?', 50) }
  scope :not_paid, -> { in_the_future }
  scope :problematic, -> { large_quantity.or(in_the_future) }

  def self.scopes 
    %i[
      in_the_future
      large_quantity
    ]
  end

  validates_presence_of :quantity, :residency, :transacted_at, :activity
  validate :expiration_date_cannot_be_in_the_future
  validate :requested_transfer_quantity_is_available
  
  def cost_per=(value)
    super
    calculate_cost_total
  end
  
  def quantity=(value)
    super
    calculate_cost_total
  end
  
  def calculate_cost_total
    self.cost_total = cost_per.to_f * quantity.to_i
  end
  
  private
  
  def expiration_date_cannot_be_in_the_future
    if transacted_at.present? && transacted_at > Time.now
      errors.add(:transacted_at, "can't be in the future")
    end
  end

  def requested_transfer_quantity_is_available
    return unless transfer?
    
    raise NotImplementedError, "must be implementd in STI child class"
  end
end
