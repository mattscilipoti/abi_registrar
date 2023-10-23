class AddUserFeePaidToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :user_fee_paid_on, :date
  end
end
