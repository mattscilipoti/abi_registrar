class ChangeDefaultCostPer < ActiveRecord::Migration[7.0]
  def change
    change_column_default :item_transactions, :cost_per, from: 0, to: nil
  end
end
