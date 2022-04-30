class RemoveShareCountFromProperty < ActiveRecord::Migration[7.0]
  def change
    remove_column :properties, :share_count, :integer, default: 0
  end
end
