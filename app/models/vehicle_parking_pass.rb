class VehicleParkingPass < AmenityPass
  # configuration
  scope :problematic, -> { without_state_code }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must start with P- and numbers'
    },
    allow_nil: true
  validates_presence_of :sticker_number, :tag_number

  scope :utility_cart_passes, -> {
    where('sticker_number ILIKE :sticker_prefix', sticker_prefix: "U%")
    .or(where('description ILIKE :description_filter', description_filter: '%GOLF%'))
    .or(where('tag_number ILIKE :tag_filter', tag_filter: '%GOLF%'))
  }

  # class-level
  def self.scopes
    super + %i[
      utility_cart_passes
      voided
      without_state_code
    ]
  end

  def self.valid_sticker_regex_ruby
    '\\AP-\\d+\\z'
  end

  def self.valid_sticker_regex_sql
    '^P-\\d+$'
  end
end
