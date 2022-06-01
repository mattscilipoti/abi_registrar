class AddMailingAddressToResidents < ActiveRecord::Migration[7.0]
  def change
    add_column :residents, :mailing_address, :hstore
  end
end
