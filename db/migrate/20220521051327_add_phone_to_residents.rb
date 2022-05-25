class AddPhoneToResidents < ActiveRecord::Migration[7.0]
  def change
    add_column :residents, :phone, :string
  end
end
