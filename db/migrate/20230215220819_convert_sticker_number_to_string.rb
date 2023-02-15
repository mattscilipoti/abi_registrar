class ConvertStickerNumberToString < ActiveRecord::Migration[7.0]
  def up
    change_column :amenity_passes, :sticker_number, :string
  end

  def down
    change_column :amenity_passes, :sticker_number, :integer
  end
end
