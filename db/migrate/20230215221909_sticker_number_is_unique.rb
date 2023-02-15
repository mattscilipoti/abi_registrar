class StickerNumberIsUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :amenity_passes, :sticker_number, unique: true
  end
end
