class AddTaxIdToProperty < ActiveRecord::Migration[7.0]
  def change
    # No need to move data, since we will just re-import
    # tax_id sub-components will be derived, rather than stored
    add_column :properties, :tax_identifier, :string
  end
end
