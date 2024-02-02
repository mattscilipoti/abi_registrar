require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Property, type: :model do
  describe 'class methods' do
    subject { described_class }

    let!(:property_no_lot) { FactoryBot.create(:property, street_name: "NO LOT") }
    let!(:property_paid) { FactoryBot.create(:property, :lot_fees_paid, street_name: "PAID") }
    let!(:property_unpaid) { FactoryBot.create(:property, :lot_fees_unpaid, street_name: "UNPAID") }

    describe 'spec setup' do
      ## There was some confusion early on, where the setup re-used lot_paid/lot_unpaid
      ##  This caused lots to be reassigned to new properties, rather than having the appropriate lots per property.
      ## Now, we test the setup to make sure it's right
      it 'property_no_lot has no (paid) lots' do
        expect(property_no_lot.lots.size).to eql(0)
        expect(property_no_lot.lot_fees_paid?).to be false
      end
      # it 'property_paid has one, paid lot' do
      #   expect(property_paid.lots.size).to eql(1)
      #   expect(property_paid.lots.first).to be_paid
      # end
      # it 'property_unpaid has one, unpaid lot' do
      #   expect(property_unpaid.lots.size).to eql(1)
      #   expect(property_unpaid.lots.first).to_not be_paid
      # end
      # it 'property_mixed has one of each (paid/unpaid) lot' do
      #   expect(property_mixed.lots.size).to eql(2)
      #   expect(property_mixed.lots.first).to be_paid
      #   expect(property_mixed.lots.last).to_not be_paid
      # end
    end

    describe 'for/not_for_sale' do
      let!(:for_sale) { property_no_lot.update_attribute(:for_sale, true) }
      let!(:not_for_sale) { property_paid.update_attribute(:for_sale, false) }

      describe 'for_sale' do
        it 'returns only properties for sale' do
          expect(subject.for_sale).to contain_exactly(property_no_lot)
        end
      end

      describe 'not_for_sale' do
        it 'returns all properties NOT for sale' do
          expect(subject.not_for_sale).to contain_exactly(property_paid, property_unpaid)
        end
      end
    end

    describe 'lot_fees_paid' do
      it 'returns only properties with all lots paid' do
        expect(subject.lot_fees_paid).to contain_exactly(property_paid)
      end
    end

    describe 'lot_fees_not_paid' do
      it 'returns all properties with at least one lot fee NOT paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(property_no_lot, property_unpaid)
      end
    end
  end

  describe '(validations)' do
    it 'can only have one owner' do
      p = FactoryBot.create(:property, :with_owner)

      expect(p).to be_valid
      expect(p.residencies.first).to be_owner

      p.residencies.build(resident_status: :owner, property: p)
      expect(p).to_not be_valid
      expect(p.errors[:residencies]).to contain_exactly(/is invalid/i)
    end
  end

  describe '(instance methods)' do
    subject(:property) { FactoryBot.create(:property) }

    describe '(tax_id related)' do
      describe 'district' do
        it 'is derived from tax_id' do
          expect(property.district('12 345 67890123')).to eql('12')
        end
      end
      describe 'subdivision' do
        it 'is derived from tax_id' do
          expect(property.subdivision('12 345 67890123')).to eql('345')
        end
      end
      describe 'account_number' do
        it 'is derived from tax_id' do
          expect(property.account_number('12 345 67890123')).to eql('67890123')
        end
      end
    end
  end
end
