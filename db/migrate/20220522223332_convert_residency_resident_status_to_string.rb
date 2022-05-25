class ConvertResidencyResidentStatusToString < ActiveRecord::Migration[7.0]
  def up
    change_column :residencies, :resident_status, :string
  end

  def down
    change_column :residencies, :resident_status, :integer
  end
end
