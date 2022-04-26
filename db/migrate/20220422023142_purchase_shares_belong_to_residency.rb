class PurchaseSharesBelongToResidency < ActiveRecord::Migration[7.0]
  def change
    add_reference :purchases, :residency, index: true, foreign_key: true
    remove_reference :purchases, :resident, index: true, foreign_key: true
  end
end
