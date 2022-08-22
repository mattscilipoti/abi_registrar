class AddTaxIdentifierToLot < ActiveRecord::Migration[7.0]
  def change
    add_column :lots, :tax_identifier, :string
  end
end
