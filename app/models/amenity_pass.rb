require 'csv' # for states

class AmenityPass < ApplicationRecord
  belongs_to :resident
  has_many :properties, through: :resident
  belongs_to :void_reason, optional: true

  validate :confirm_resident_paid_mandatory_fees
  validates :sticker_number, uniqueness: true
  validates :sticker_number,
    format: {
      with: /\A[A-Z]-\d+\z/,
      message: 'must be letter-hyphen-digits like A-123'
    },
    if: :sticker_requires_letter_prefix?

  def self.scopes
    [:not_voided, :voided, :voided_legacy, :with_valid_sticker_number, :with_invalid_sticker_number]
  end

  # List of searchable columns for this Model
  # ! this must be declared before pg_search_scope
  def self.searchable_columns
    [:beach_number, :description, :location, :state_code, :sticker_number, :tag_number]
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

  scope :not_voided, -> { where(voided_at: nil) }
  scope :voided, -> { where.not(voided_at: nil) }
  scope :voided_legacy, -> { where('description ILIKE :void OR sticker_number ILIKE :void', void: "%VOID%") }
  # Valid by STI type:
  # - BeachPass:            ^\d+$
  # - BoatRampAccessPass:   ^R-\d+$
  # - DinghyDockStoragePass:^D-\d+$
  # - UtilityCartPass:      ^U-\d+$
  # - VehicleParkingPass:   ^P-\d+$
  # - WatercraftStoragePass:^W-\d+$
  # - Others/default:       ^[A-Z]-\d+$
  scope :with_valid_sticker_number, -> {
    where(<<~SQL)
      CASE amenity_passes.type
        WHEN 'BeachPass' THEN amenity_passes.sticker_number ~ '^\\d+$'
        WHEN 'BoatRampAccessPass' THEN amenity_passes.sticker_number ~ '^R-\\d+$'
        WHEN 'DinghyDockStoragePass' THEN amenity_passes.sticker_number ~ '^D-\\d+$'
        WHEN 'UtilityCartPass' THEN amenity_passes.sticker_number ~ '^U-\\d+$'
        WHEN 'VehicleParkingPass' THEN amenity_passes.sticker_number ~ '^P-\\d+$'
        WHEN 'WatercraftStoragePass' THEN amenity_passes.sticker_number ~ '^W-\\d+$'
        ELSE amenity_passes.sticker_number ~ '^[A-Z]-\\d+$'
      END
    SQL
  }
  scope :with_invalid_sticker_number, -> {
    where.not(id: with_valid_sticker_number.select(:id))
  }
  scope :without_description, -> { where(description: nil) }
  scope :without_state_code, -> { where(state_code: nil) }
  scope :without_tag_number, -> { where(tag_number: nil) }

  def self.default_sort
    { column: :sticker_number, direction: :desc }
  end

  # Useful for form collections
  # Displays summary, returns code
  # With
  def self.states
    @states ||= begin
      data_file = Rails.root.join('db', 'import', 'US_States.csv')
      state_data = table = CSV.table(data_file,
        encoding: "bom|utf-8",
        header_converters: [:downcase, :symbol],
        headers: :first_row,
        skip_blanks: true,
        strip: true,
      )
      default_state = { "MD-Maryland" => "MD" }
      state_data.inject(default_state) do |states, row|
        name = row.fetch(:state)
        code = row.fetch(:code)
        summary = [code, name].join('-')
        states[summary] = code
        states
      end
    end
  end

  def tag
    [state_code, tag_number].compact.join('-')
  end

  def to_param
    [id, sticker_number].compact.join('-')
  end

  def to_s
    [sticker_number, tag].compact.join(', ')
  end

  def void
    update_columns(voided_at: Time.current)
  end

  def voided?
    voided_at?
  end

  # Returns the selected standard reason label if present; otherwise the free-text voided_reason
  def void_reason_label
    void_reason&.label.presence || voided_reason
  end

  private

  # By default, amenity passes expect a letter-hyphen-digits sticker format.
  # Subclasses can override to disable or change behavior (e.g., BeachPass).
  def sticker_requires_letter_prefix?
    true
  end

  def confirm_resident_paid_mandatory_fees
    unless resident && resident.lot_fees_paid?
      errors.add(:resident, "must have paid lot fees")
    end
    unless resident && resident.user_fee_paid?
      errors.add(:resident, "must have paid user fee")
    end
  end

end
