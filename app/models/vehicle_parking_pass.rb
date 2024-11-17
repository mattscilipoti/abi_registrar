class VehicleParkingPass < AmenityPass
  scope :problematic, -> { without_state_code }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates_presence_of :tag_number, :sticker_number

  scope :utility_cart_passes, -> { where("sticker_number ILIKE :prefix", prefix: "U%") }

  def self.scopes
    %i[
      utility_cart_passes
      without_state_code
    ]
  end
end
