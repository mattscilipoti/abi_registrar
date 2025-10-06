class BoatRampAccessPass < AmenityPass
  # configuration
  scope :problematic, -> { without_description.or(without_tag_number) }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must start with R- and numbers'
    },
    allow_nil: true
  validates_presence_of :sticker_number

  # class-level
  def self.scopes
    super + %i[
      without_description
      without_tag_number
    ]
  end

  def self.valid_sticker_regex_ruby
    '\\AR-\\d+\\z'
  end

  def self.valid_sticker_regex_sql
    '^R-\\d+$'
  end

  # instance-level (public)
  def to_s
    [sticker_number, tag, description&.truncate(50)].compact.join(', ')
  end
end
