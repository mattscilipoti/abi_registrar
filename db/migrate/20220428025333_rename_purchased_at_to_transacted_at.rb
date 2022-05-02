class RenamePurchasedAtToTransactedAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :item_transactions, :purchased_at, :transacted_at
  end
end
