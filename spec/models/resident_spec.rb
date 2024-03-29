require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    context "(lot fees)" do

      let(:property_paid) { FactoryBot.create(:property, :lot_fees_paid, street_name: "PAID") }
      let(:property_unpaid) { FactoryBot.create(:property, :lot_fees_unpaid, street_name: "UNPAID") }
      let!(:resident_paid) { FactoryBot.create(:resident, last_name: 'PAID', properties: [property_paid]) }
      let!(:resident_unpaid) { FactoryBot.create(:resident, last_name: 'UNPAID', properties: [property_unpaid]) }

      describe '.lot_fees_paid' do
        it 'returns only residents who paid lot fees for ALL their properties' do
          expect(subject.lot_fees_paid).to contain_exactly(resident_paid)
        end
      end

      describe '.lot_fees_not_paid' do
        it 'returns any property where lot fees are not paid' do
          expect(subject.lot_fees_not_paid).to contain_exactly(resident_unpaid)
        end
      end
    end

    context '(search)' do
      let!(:fred) do
        FactoryBot.create(:resident, last_name: 'FLINTSTONE, JR', first_name: 'FREDERICK', middle_name: 'J')
      end

      let!(:wilma) do
        FactoryBot.create(:resident, last_name: 'FLINTSTONE', first_name: 'WILMA', middle_name: 'B')
      end

      describe '.search_by_name' do
        it 'finds by exact last_name, case-insensitive' do
          residents = Resident.search_by_name("FLINTSTONE")
          expect(residents).to contain_exactly(fred, wilma)
        end

        it 'finds partial names' do
          residents = Resident.search_by_name("Flintstone, Fred")
          expect(residents).to contain_exactly(fred)
        end
      end

      describe '.search_by_name_sounds_like' do
        it 'finds by exact last_name, case-insensitive' do
          residents = Resident.search_by_name_sounds_like("frederick")
          expect(residents).to contain_exactly(fred)
        end

        it 'finds by similar sounding last_name, case-insensitive' do
          residents = Resident.search_by_name_sounds_like("fredarick")
          expect(residents).to contain_exactly(fred)
        end
      end
    end

    describe '.without_primary_residence' do
      let(:property1) { FactoryBot.create(:property, :with_paid_lots, street_name: "PRIMARY RES") }
      let!(:resident_with_primary_residence) do
        FactoryBot.create(:resident, last_name: 'WITH_PRIMARY_RES').tap do |r|
          r.residencies << FactoryBot.create(:residency, property: property1, resident: r)
        end
      end
      let!(:resident_without_primary_residence) do
        FactoryBot.create(:resident, last_name: 'WITHOUT_PRIMARY_RES').tap do |r|
          r.residencies << FactoryBot.create(:residency, :coowner, :second_home, property: property1, resident: r)
        end
      end

      it 'should return all residents without a primary residence' do
        expect(Resident.without_primary_residence).to contain_exactly(resident_without_primary_residence)
      end
    end
  end

  describe '(instance methods)' do
    subject(:resident) { FactoryBot.build(:resident) }

    describe '(validations)' do
      # SKIP: non-numberic chars are removed
      # it 'ensures phone is JUST numbers' do
      #   resident.phone = '1234567890'
      #   expect(resident).to be_valid
      #   resident.phone = '123-456-7890'
      #   expect(resident).to_not be_valid
      #   expect(resident.errors[:phone]).to contain_exactly(/only allows numbers/)
      # end
    end

    describe '#phone' do
      it 'removes all non-number chars' do
        subject.phone = '(555) 443-1212'
        expect(subject.phone).to eql('5554431212')
      end
    end

    describe '#primary_residence/residency' do
      let!(:r_primary) { FactoryBot.create(:residency, resident: subject) }
      let!(:r_second)  { FactoryBot.create(:residency, :second_home, resident: subject) }

      it 'returns the property that is the primary residence' do
        expect(subject.residencies.size).to eql(2)
        expect(subject.primary_residence).to eq(r_primary.property)
      end

      it 'returns the residency that is the primary residency' do
        expect(subject.residencies.size).to eql(2)
        expect(subject.primary_residency).to eq(r_primary)
      end
    end

    describe '#user_fee_paid?' do
      it 'returns failse if no properties are assigned' do
        subject.properties = []
        expect(subject.user_fee_paid?).to be false
      end
    end
  end
end
