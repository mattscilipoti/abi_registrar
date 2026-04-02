class UtilityCartPass < AmenityPass
  # configuration
  scope :problematic, -> { without_description }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must start with U- and numbers'
    },
    allow_nil: true
  validates_presence_of :sticker_number

  # class-level
  def self.scopes
    super + [:without_description]
  end

  def self.valid_sticker_regex_ruby
    '\\AU-\\d+\\z'
  end

  def self.valid_sticker_regex_sql
    '^U-\\d+$'
  end

  # instance-level (public)
  def to_s
    [sticker_number, description&.truncate(20)].compact.join(', ')
  end
end
