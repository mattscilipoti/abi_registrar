class VehicleParkingPass < AmenityPass
  scope :problematic, -> { without_state_code }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates_presence_of :tag_number, :sticker_number
  validates :sticker_number,
    format: {
      with: /\AP/,
      message: 'must start with P'
    },
    allow_nil: true

  scope :utility_cart_passes, -> {
    where('sticker_number ILIKE :sticker_prefix', sticker_prefix: "U%")
    .or(where('description ILIKE :description_filter', description_filter: '%GOLF%'))
    .or(where('tag_number ILIKE :tag_filter', tag_filter: '%GOLF%'))
  }

  def self.scopes
    super + %i[
      utility_cart_passes
      voided
      without_state_code
    ]
  end
end
