
class BoatRampPass < AmenityPass
  scope :problematic, -> { without_description }

  validates_presence_of :sticker_number

  def self.scopes
    super + [:without_description]
  end

  def to_s
    [sticker_number, description&.truncate(20)].compact.join(', ')
  end
end
