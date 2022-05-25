class RemoveAgeOfMinor < ActiveRecord::Migration[7.0]
  def change
    remove_column :residents, :age_of_minor, :text
  end
end
