class BeachPass < AmenityPass
  scope :problematic, -> { without_description }

  validates_presence_of :sticker_number
  validates :sticker_number,
    format: {
      with: /\A\d+\z/,
      message: 'must be digits only like 12345'
    },
    allow_nil: true

  private

  def sticker_requires_letter_prefix?
    false
  end

  def self.scopes
    super + %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, resident.full_name].compact.join(', ')
  end
end
