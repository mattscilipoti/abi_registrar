class VehicleParkingPass < AmenityPass
  scope :problematic, -> { without_state_code }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates_presence_of :tag_number, :sticker_number

  def self.scopes
    %i[
      without_state_code
    ]
  end

  def to_s
    [sticker_number, tag].compact.join(', ')
  end
end
