class BeachPass < AmenityPass
  scope :problematic, -> { without_description }

  validates_presence_of :sticker_number

  def self.scopes
    super + %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, resident.full_name].compact.join(', ')
  end
end
