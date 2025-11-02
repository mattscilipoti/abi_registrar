require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    describe "reset_amenities_processed" do
      before(:each) do
        FactoryBot.create_list(:property, 2, :mandatory_fees_paid, amenities_processed: 1.day.ago)
        FactoryBot.create_list(:property, 1, :mandatory_fees_paid, amenities_processed: nil)
        expect(Property.count).to eql(3)
        expect(Property.amenities_processed.count).to eql(2)
        expect(Property.where(amenities_processed: nil).count).to eql(1)
      end

      it 'clears all amenities_processed' do
        expect { YearEnd.reset_amenities_processed }.to change(Property.amenities_processed, :count).by(-2)\
      end
    end

    context "(resetting fees)" do
      before(:each) do
        FactoryBot.create_list(:lot, 2, paid_on: 1.day.ago)
        FactoryBot.create_list(:lot, 1, paid_on: nil)
        expect(Lot.count).to eql(3)
        expect(Lot.fee_paid.count).to eql(2)
        expect(Lot.fee_not_paid.count).to eql(1)
        FactoryBot.create_list(:property, 2, :mandatory_fees_paid, amenities_processed: 1.day.ago)
        FactoryBot.create_list(:property, 1, :lot_fees_unpaid, :user_fee_unpaid, amenities_processed: nil)
        expect(Property.count).to eql(3)
        expect(Property.lot_fees_paid.count).to eql(2)
        expect(Property.lot_fees_not_paid.count).to eql(1)
        expect(Property.user_fee_paid.count).to eql(2)
        expect(Property.user_fee_not_paid.count).to eql(1)
      end

      describe "reset_lot_fees" do
        it 'clears all Lot#paid_on' do
          expect { YearEnd.reset_lot_fees }.to change(Lot.fee_paid, :count).by(-2)
        end

        it 'clears all Property#lot_fees_paid_on' do
          expect { YearEnd.reset_lot_fees }.to change(Property.lot_fees_paid, :count).by(-2)
        end
      end

      describe "reset_fees" do
        it 'clears all Lot#paid_on' do
          expect { YearEnd.reset_fees }.to change(Lot.fee_paid, :count).by(-2)
        end

        it 'clears all Property#lot_fees_paid_on' do
          expect { YearEnd.reset_fees }.to change(Property.lot_fees_paid, :count).by(-2)
        end

        it 'clears all Property#amenities_processed' do
          expect { YearEnd.reset_fees }.to change(Property.amenities_processed, :count).by(-2)
        end

        it 'clears all Property#user_fee_paid_on' do
          expect { YearEnd.reset_fees }.to change(Property.user_fee_paid, :count).by(-2)
        end

        it 'increments amenity pass season_year from current -> next year' do
          current = Time.zone.now.year
          next_year = current + 1

          # create some amenity passes for current and previous years
          FactoryBot.create_list(:beach_pass, 2, season_year: current)
          FactoryBot.create(:beach_pass, season_year: current - 1)

          expect(AmenityPass.where(season_year: current).count).to eql(2)
          expect(AmenityPass.where(season_year: next_year).count).to eql(0)

          expect { YearEnd.reset_fees }.to change { AmenityPass.where(season_year: current).count }.by(-2)

          # the two current-year passes should now be next year's
          expect(AmenityPass.where(season_year: next_year).count).to eql(2)
        end
      end
    end
  end
end
