class RenameTransferTypeToTransferActivity < ActiveRecord::Migration[7.0]
  def change
    rename_column :item_transactions, :transaction_type, :activity
  end
end
