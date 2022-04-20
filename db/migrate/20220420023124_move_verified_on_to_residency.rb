class MoveVerifiedOnToResidency < ActiveRecord::Migration[7.0]
  def change
    add_column :residencies, :verified_on, :date
    remove_column :residents, :verified_at, :datetime
  end
end
