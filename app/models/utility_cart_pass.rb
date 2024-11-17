class UtilityCartPass < AmenityPass
  scope :problematic, -> { without_description }

  validates_presence_of :sticker_number

  def self.scopes
    %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, description&.truncate(20)].compact.join(', ')
  end
end
