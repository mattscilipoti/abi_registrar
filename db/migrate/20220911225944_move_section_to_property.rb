class MoveSectionToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :section, :integer
    remove_column :lots, :section, :integer
  end
end
