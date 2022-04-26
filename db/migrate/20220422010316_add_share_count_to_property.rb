class AddShareCountToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :share_count, :integer, default: 0
  end
end
