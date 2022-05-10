class ItemTransaction < ApplicationRecord
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
  enum :activity, { purchase: 'Purchase', transfer: 'Transfer' }
  belongs_to :residency
  belongs_to :from_residency, class_name: 'Residency', optional: true
  has_one :from_resident, through: :from_residency, source: :resident, required: false
  has_one :from_property, through: :from_residency, source: :property, required: false
  has_one :resident, through: :residency
  has_one :property, through: :residency

  validates_presence_of :quantity, :residency, :transacted_at, :activity
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

  def requested_transfer_quantity_is_available
    return unless transfer?

    raise NotImplementedError, "must be implementd in STI child class"
  end
end
