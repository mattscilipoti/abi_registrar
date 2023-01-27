class AmenityTagNumberIsNotRequired < ActiveRecord::Migration[7.0]
  def change
    change_column_null :amenities, :tag_number, true
  end
end
