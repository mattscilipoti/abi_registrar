class BoatRampAccessPass < AmenityPass
   scope :problematic, -> { without_description.or(without_tag_number) }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates_presence_of :sticker_number
  validates :sticker_number,
    format: {
      with: /\AR/,
      message: 'must start with R'
    },
    allow_nil: true

  def self.scopes
    super + %i[
      without_description
      without_tag_number
    ]
  end

  def to_s
    [sticker_number, tag, description&.truncate(50)].compact.join(', ')
  end
end
