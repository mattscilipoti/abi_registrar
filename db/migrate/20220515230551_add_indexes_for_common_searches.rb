class AddIndexesForCommonSearches < ActiveRecord::Migration[7.0]
  def change
    add_index :lots, :lot_number
    add_index :lots, :paid_on

    add_index :properties, :street_number
    add_index :properties, :street_name

    add_index :residencies, :resident_status
    add_index :residencies, :verified_on

    add_index :residents, :last_name
  end
end
