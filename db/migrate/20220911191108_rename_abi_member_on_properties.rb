class RenameAbiMemberOnProperties < ActiveRecord::Migration[7.0]
  def change
    rename_column :properties, :abi_member, :membership_eligible
  end
end
