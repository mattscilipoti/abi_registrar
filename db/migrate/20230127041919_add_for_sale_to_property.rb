class AddForSaleToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :for_sale, :boolean
  end
end
