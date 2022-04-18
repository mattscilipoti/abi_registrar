class AddResidentStatusToResidency < ActiveRecord::Migration[7.0]
  def change
    add_column :residencies, :resident_status, :integer
  end
end
