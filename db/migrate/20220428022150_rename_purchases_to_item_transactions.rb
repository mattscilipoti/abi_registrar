class RenamePurchasesToItemTransactions < ActiveRecord::Migration[7.0]
  def change
    rename_table "purchases", "item_transactions"
  end
end
