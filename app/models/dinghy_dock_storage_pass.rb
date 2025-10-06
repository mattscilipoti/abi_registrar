class DinghyDockStoragePass < AmenityPass
  # configuration
  scope :problematic, -> { without_description }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must start with D- and numbers'
    },
    allow_nil: true
  validates_presence_of :beach_number, :description, :sticker_number

  # class-level
  def self.scopes
    super + %i[
      without_description
    ]
  end

  def self.valid_sticker_regex_ruby
    '\\AD-\\d+\\z'
  end

  def self.valid_sticker_regex_sql
    '^D-\\d+$'
  end

  # instance-level (public)
  def to_s
    [sticker_number, beach_number, location].compact.join(', ')
  end
end
