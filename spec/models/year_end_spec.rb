require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    describe "clear_amenities_processed" do
      before(:each) do
        FactoryBot.create_list(:property, 2, :mandatory_fees_paid, amenities_processed: 1.day.ago)
        FactoryBot.create_list(:property, 1, :mandatory_fees_paid, amenities_processed: nil)
        expect(Property.count).to eql(3)
        expect(Property.amenities_processed.count).to eql(2)
        expect(Property.where(amenities_processed: nil).count).to eql(1)
      end

      it 'clears all amenities_processed' do
        expect { YearEnd.clear_amenities_processed }.to change(Property.amenities_processed, :count).by(-2)\
      end
    end

    context "(processing year-end)" do
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

      describe "clear_lot_payment_dates" do
        it 'clears all Lot#paid_on' do
          expect { YearEnd.clear_lot_payment_dates }.to change(Lot.fee_paid, :count).by(-2)
        end

        it 'clears all Property#lot_fees_paid_on' do
          expect { YearEnd.clear_lot_payment_dates }.to change(Property.lot_fees_paid, :count).by(-2)
        end
      end

      describe "process_year_end" do
        it 'clears all Lot#paid_on' do
          expect { YearEnd.process_year_end }.to change(Lot.fee_paid, :count).by(-2)
        end

        it 'clears all Property#lot_fees_paid_on' do
          expect { YearEnd.process_year_end }.to change(Property.lot_fees_paid, :count).by(-2)
        end

        it 'clears all Property#amenities_processed' do
          expect { YearEnd.process_year_end }.to change(Property.amenities_processed, :count).by(-2)
        end

        it 'clears all Property#user_fee_paid_on' do
          expect { YearEnd.process_year_end }.to change(Property.user_fee_paid, :count).by(-2)
        end

        it 'advances configured season year without modifying AmenityPass records' do
          current = Time.zone.now.year
          next_year = current + 1

          # Ensure the configured season year matches the current year
          AppSetting.set('current_season_year', current.to_s)

          # create some amenity passes for current and previous years
          FactoryBot.create_list(:beach_pass, 2, season_year: current)
          FactoryBot.create(:beach_pass, season_year: current - 1)

          expect(AmenityPass.where(season_year: current).count).to eql(2)
          expect(AmenityPass.where(season_year: next_year).count).to eql(0)

          # Running year-end should NOT mutate existing pass records
          expect { YearEnd.process_year_end }.to_not change { AmenityPass.count }
          expect(AmenityPass.where(season_year: current).count).to eql(2)

          # Only the configured/persisted season year should advance
          expect(AppSetting.current_season_year).to eql(next_year)
        end
      end
    end
  end
end
