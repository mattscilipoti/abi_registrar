class ConvertTransactionAcivityToSearchableString < ActiveRecord::Migration[7.0]
  def change
    change_column :item_transactions, :activity, :string
  end
end
