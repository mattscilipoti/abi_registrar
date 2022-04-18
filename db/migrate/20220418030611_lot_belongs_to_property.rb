class LotBelongsToProperty < ActiveRecord::Migration[7.0]
  def change
    add_reference :lots, :property, foreign_key: true
  end
end
