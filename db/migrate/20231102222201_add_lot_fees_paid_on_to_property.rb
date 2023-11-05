class AddLotFeesPaidOnToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :lot_fees_paid_on, :date

    reversible do |dir|
      dir.up do
        say_with_time('Update lot_fees_paid_on from most recent lot.paid_on') do
          Property.reset_column_information
          properties_with_paid_lot_fees = Property.lot_fees_paid
          properties_with_paid_lot_fees.each do |property|
            property_paid_lots = property.lots.fee_paid.order(paid_on: :desc)
            next if property_paid_lots.blank? # why do some Property.lot_fees_paid have no paid lots?

            most_recent_lot_fee_paid_on = property_paid_lots.first.paid_on
            property.update_attribute(:lot_fees_paid_on, most_recent_lot_fee_paid_on)
          end
          properties_with_paid_lot_fees.size
        end
      end
    end
  end
end
