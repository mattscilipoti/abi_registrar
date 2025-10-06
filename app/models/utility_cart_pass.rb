class UtilityCartPass < AmenityPass
  scope :problematic, -> { without_description }

  validates_presence_of :sticker_number
  validates :sticker_number,
    format: {
      with: /\AU/,
      message: 'must start with U'
    },
    allow_nil: true

  def self.scopes
    super + [:without_description]
  end

  def to_s
    [sticker_number, description&.truncate(20)].compact.join(', ')
  end
end
