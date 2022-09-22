class RemoveTaxIdFromLot < ActiveRecord::Migration[7.0]
  def change
    remove_column :lots, :district, :integer
    remove_column :lots, :subdivision, :integer
    remove_column :lots, :account_number, :integer
    remove_column :lots, :tax_identifier, :string
  end
end
