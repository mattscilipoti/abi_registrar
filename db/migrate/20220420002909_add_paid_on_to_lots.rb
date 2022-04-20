class AddPaidOnToLots < ActiveRecord::Migration[7.0]
  def change
    add_column :lots, :paid_on, :date
  end
end
