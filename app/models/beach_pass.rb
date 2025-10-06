class BeachPass < AmenityPass
  # configuration
  scope :problematic, -> { without_description }

  validates :sticker_number,
    format: {
      with: ->(rec) { Regexp.new(rec.class.valid_sticker_regex_ruby) },
      message: 'must be digits only like 12345'
    },
    allow_nil: true
  validates_presence_of :sticker_number

  # class-level
  def self.scopes
    super + %i[
      without_description
    ]
  end

  def self.valid_sticker_regex_ruby
    '^\d+$'
  end

  def self.valid_sticker_regex_sql
    '^\\d+$'
  end

  # instance-level (public)
  def to_s
    [sticker_number, resident.full_name].compact.join(', ')
  end

  private

  def sticker_requires_letter_prefix?
    false
  end
end
