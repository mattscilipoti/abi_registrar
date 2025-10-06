class WatercraftStoragePass < AmenityPass
  # configuration
  alias_attribute :rack_slot_number, :location
  scope :problematic, -> { without_description }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must start with W- and numbers'
    },
    allow_nil: true
  validates_presence_of :beach_number, :description, :rack_slot_number, :sticker_number

  # class-level
  def self.scopes
    super + %i[
      without_description
    ]
  end

  def self.valid_sticker_regex_ruby
    '\\AW-\\d+\\z'
  end

  def self.valid_sticker_regex_sql
    '^W-\\d+$'
  end

  # instance-level (public)
  def to_s
    [sticker_number, beach_number, location].compact.join(', ')
  end
end
