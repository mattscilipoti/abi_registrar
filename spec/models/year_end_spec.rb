require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    describe "reset_amenities_processed" do
      before(:each) do
        FactoryBot.create_list(:property, 2, amenities_processed: 1.day.ago)
        FactoryBot.create_list(:property, 1, amenities_processed: nil)
        expect(Property.count).to eql(3)
        expect(Property.amenities_processed.count).to eql(2)
        expect(Property.where(amenities_processed: nil).count).to eql(1)
      end

      it 'clears all user_fee_paid' do
        expect { YearEnd.reset_amenities_processed }.to change(Property.amenities_processed, :count).by(-2)\
      end
    end

    describe "reset_lot_fees" do
      before(:each) do
        FactoryBot.create_list(:lot, 2, paid_on: 1.day.ago)
        FactoryBot.create_list(:lot, 1, paid_on: nil)
        expect(Lot.count).to eql(3)
        expect(Lot.fee_paid.count).to eql(2)
        expect(Lot.fee_not_paid.count).to eql(1)
        FactoryBot.create_list(:property, 2, lot_fees_paid_on: 1.day.ago)
        FactoryBot.create_list(:property, 1, lot_fees_paid_on: nil)
        expect(Property.count).to eql(3)
        expect(Property.lot_fees_paid.count).to eql(2)
        expect(Property.lot_fees_not_paid.count).to eql(1)
      end

      it 'clears all Lot#paid_on' do
        expect { YearEnd.reset_lot_fees }.to change(Lot.fee_paid, :count).by(-2)
      end

      it 'clears all Property#lot_fees_paid_on' do
        expect { YearEnd.reset_lot_fees }.to change(Property.lot_fees_paid, :count).by(-2)
      end
    end
  end
end
