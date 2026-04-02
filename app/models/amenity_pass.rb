require 'csv' # for states

class AmenityPass < ApplicationRecord
  include PassYearable

  # Associations
  belongs_to :resident
  has_many :properties, through: :resident
  belongs_to :void_reason, optional: true

  # Validations (alphabetical)
  validate  :confirm_resident_paid_mandatory_fees
  validate  :season_year_in_configured_range
  validates :resident, presence: true
  validates :season_year, presence: true, if: :require_season_year_on_save?
  validates :sticker_number, presence: true, uniqueness: true
  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must be letter-hyphen-digits like A-123'
    },
    if: :sticker_requires_letter_prefix?

  def self.scopes
    [:not_voided, :voided, :voided_legacy, :with_valid_sticker_number, :without_valid_sticker_number]
  end


  # Scopes (alphabetical)
  scope :not_paid, -> { where('1=2') } # TODO: sticker fee not paid?
  # scope :problematic, -> { without_state_code }
  scope :without_description, -> { where(description: nil) }
  scope :without_state_code, -> { where(state_code: nil) }
  scope :without_tag_number, -> { where(tag_number: nil) }
  scope :not_voided, -> { where(voided_at: nil) }
  scope :voided, -> { where.not(voided_at: nil) }
  scope :voided_legacy, -> { where('description ILIKE :void OR sticker_number ILIKE :void', void: "%VOID%") }
  # Build OR conditions using each subclass' published regex.
  scope :with_valid_sticker_number, -> {
    klasses = (AmenityPass.descendants + [AmenityPass]).uniq
    clauses = []
    binds = []

    subclass_names = []
    klasses.each do |k|
      regex = k.valid_sticker_regex_sql
      if k == AmenityPass
        # handled as fallback below
        next
      else
        subclass_names << k.name
        clauses << "(amenity_passes.type = ? AND amenity_passes.sticker_number ~ ?)"
        binds += [k.name, regex]
      end
    end

    # Fallback for any records with unrecognized type (or direct AmenityPass if present)
    clauses << "(amenity_passes.type IS NULL OR amenity_passes.type NOT IN (?)) AND amenity_passes.sticker_number ~ ?"
    binds += [subclass_names, AmenityPass.valid_sticker_regex_sql]

    where(clauses.join(' OR '), *binds)
  }
  scope :without_valid_sticker_number, -> {
    where.not(id: with_valid_sticker_number.select(:id))
  }
  scope :without_description, -> { where(description: nil) }
  scope :without_state_code, -> { where(state_code: nil) }
  scope :without_tag_number, -> { where(tag_number: nil) }


  # Class methods (alphabetical)
  def self.available_years
    where.not(season_year: nil).distinct.order(season_year: :desc).pluck(:season_year)
  end

  def self.default_sort
    { column: :sticker_number, direction: :desc }
  end

  # Initialization / includes
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

  # Default valid regex (PostgreSQL) for sticker_number; subclasses override.
  def self.valid_sticker_regex_sql
    '^[A-Z]-\\d+$'
  end

  # Default valid regex (Ruby) for sticker_number; subclasses override.
  def self.valid_sticker_regex_ruby
    '\\A[A-Z]-\\d+\\z'
  end

  # Attempt to guess a season year from a sticker string.
  # Accepts values like "R-250123" or "250123" and returns 20YY when
  # the first two digits are interpreted as the two-digit year (YY -> 20YY).
  # This method performs only parsing (no application-level bounds checks);
  # callers should validate the parsed year as needed. Returns an Integer
  # (e.g. 2025) or nil when no two-digit year can be parsed.
  def self.guess_season_year_from_sticker(sticker, range_back: 4)
    return nil if sticker.blank?
    m = sticker.to_s.match(/\d+/)
    return nil unless m
    digits = m[0]
    return nil if digits.length < 2

    yy = digits[0,2].to_i
    2000 + yy
  end

  # Scopes for filter bar
  def self.scopes
    []
  end

  # Useful for form collections
  # Displays summary, returns code
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

  # Instance methods (alphabetical)
  def confirm_resident_paid_lot_fees
    unless resident && resident.lot_fees_paid?
      errors.add(:resident, "must have paid lot fees")
    end
  end

  def confirm_resident_paid_mandatory_fees
    confirm_resident_paid_lot_fees
    confirm_resident_paid_user_fee
  end

  def confirm_resident_paid_user_fee
    unless resident && resident.user_fee_paid?
      errors.add(:resident, "must have paid user fee")
    end
  end

  # Instance wrapper that uses the model's sticker_digits helper.
  def guess_season_year_from_sticker(range_back: 4)
    digits = sticker_digits
    return nil if digits.blank? || digits.length < 2
    # Delegate to the class-level parser to avoid duplicating logic.
    self.class.guess_season_year_from_sticker(digits, range_back: range_back)
  end

  # Return the first contiguous run of digits found in `sticker_number`.
  # Examples:
  #  "VOID R-25134" => "25134"
  #  "R-24164 (VOID) - NOT RECEIVED" => "24164"
  # Returns a String of digits, or nil if no digits present.
  def sticker_digits
    return nil if sticker_number.blank?
    m = sticker_number.to_s.match(/\d+/)
    m && m[0]
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


  def confirm_resident_paid_mandatory_fees
    unless resident && resident.lot_fees_paid?
      errors.add(:resident, "must have paid lot fees")
    end
    unless resident && resident.user_fee_paid?
      errors.add(:resident, "must have paid user fee")
    end
  end

  # Return true for new records or any record that is being changed/saved.
  # This enforces presence for created records and for any update operation.
  def require_season_year_on_save?
    new_record? || changed?
  end

  def season_year_in_configured_range
    return if season_year.nil?

    unless season_year.is_a?(Integer)
      errors.add(:season_year, 'must be an integer')
      return
    end

    # The minimum allowed season year is configurable via AppSetting.min_season_year.
    # Use AppSetting.max_season_year for the upper bound so the app can accept
    # next-season values when configured.
    min = AppSetting.min_season_year
    max = AppSetting.max_season_year

    if season_year < min
      errors.add(:season_year, "must be greater than or equal to #{min}")
    elsif season_year > max
      errors.add(:season_year, "must be less than or equal to #{max}")
    end
  end

  # By default, amenity passes expect a letter-hyphen-digits sticker format.
  # Subclasses can override to disable or change behavior (e.g., BeachPass).
  def sticker_requires_letter_prefix?
    true
  end
end
