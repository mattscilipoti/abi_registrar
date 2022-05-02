class AddTransactionTypeToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :transaction_type, :integer
  end
end
