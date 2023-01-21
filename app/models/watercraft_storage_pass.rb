class WatercraftStoragePass < Amenity
  alias_attribute :rack_slot_number, :location
  scope :problematic, -> { without_description }
  # scope :without_state_code, -> { where(state_code: nil) }

  validates_presence_of :beach_number, :description, :rack_slot_number, :sticker_number

  def self.scopes
    %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, beach_number, location].compact.join(', ')
  end
end
