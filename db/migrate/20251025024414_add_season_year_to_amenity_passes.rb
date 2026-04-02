class AddSeasonYearToAmenityPasses < ActiveRecord::Migration[7.0]
  def up
    add_column :amenity_passes, :season_year, :integer
    add_index  :amenity_passes, :season_year

    # Optionally enable NOT NULL after verifying backfill:
    # change_column_null :amenity_passes, :season_year, false
  end

  def down
    remove_index :amenity_passes, :season_year
    remove_column :amenity_passes, :season_year
  end
end
