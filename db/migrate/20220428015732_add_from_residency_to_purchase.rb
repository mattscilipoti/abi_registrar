class AddFromResidencyToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_reference :purchases, :from_residency, null: true, foreign_key: { to_table: :residencies }
  end
end
