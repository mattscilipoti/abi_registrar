class AddResidentSeasonIndexToAmenityPasses < ActiveRecord::Migration[7.0]
  # Table is small in production (<10k rows). Use a normal index build which is
  # simpler and runs inside the migration transaction.
  def change
    # Composite index to speed up queries that filter by season_year and resident_id
    add_index :amenity_passes,
              [:season_year, :resident_id],
              name: 'index_amenity_passes_on_season_year_and_resident_id'
  end
end
