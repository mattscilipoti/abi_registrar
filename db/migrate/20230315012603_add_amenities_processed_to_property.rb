class AddAmenitiesProcessedToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :amenities_processed, :date
  end
end
