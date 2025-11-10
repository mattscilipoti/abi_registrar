class UtilityCartPass < AmenityPass
  scope :problematic, -> { without_description }

  def self.scopes
    %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, description&.truncate(20)].compact.join(', ')
  end
end
