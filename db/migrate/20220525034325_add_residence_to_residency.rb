class AddResidenceToResidency < ActiveRecord::Migration[7.0]
  def change
    add_column :residencies, :residence, :boolean
  end
end
