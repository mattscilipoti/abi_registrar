class AddMissingNotNulls < ActiveRecord::Migration[7.0]
  # see: https://github.com/gregnavis/active_record_doctor#detecting-missing-non-null-constraints
  def change
    change_column_null :item_transactions, :activity, false
    change_column_null :item_transactions, :quantity, false
    change_column_null :item_transactions, :transacted_at, false
    change_column_null :item_transactions, :residency_id, false

    change_column_null :residents, :last_name, false

    change_column_null :vehicles, :tag_number, false
    change_column_null :vehicles, :sticker_number, false
  end
end
