class BeachPass < AmenityPass
  scope :problematic, -> { without_description }

  def self.scopes
    %i[
      without_description
    ]
  end

  def to_s
    [sticker_number, resident.full_name].compact.join(', ')
  end
end
