class AddAbiMemberToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :abi_member, :boolean
  end
end
