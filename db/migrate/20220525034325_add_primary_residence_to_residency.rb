class AddPrimaryResidenceToResidency < ActiveRecord::Migration[7.0]
  def change
    add_column :residencies, :primary_residence, :boolean
  end
end
