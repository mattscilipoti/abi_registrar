require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Property, type: :model do
  describe 'class methods' do
    subject { described_class }

    let!(:property_mixed) { FactoryBot.create(:property, :with_paid_lots, :with_unpaid_lots, street_name: "MIXED") }
    let!(:property_paid) { FactoryBot.create(:property, :with_paid_lots, street_name: "PAID") }
    let!(:property_unpaid) { FactoryBot.create(:property, :with_unpaid_lots, street_name: "UNPAID") }

    describe 'spec setup' do
      ## There was some confusion early on, where the setup re-used lot_paid/lot_unpaid
      ##  This cause lots to be reassigned to new properties, rather than having the appropriate lots per property.
      ## Now, we test the setup to make sure it's right
      it 'property_paid has one, paid lot' do
        expect(property_paid.lots.size).to eql(1)
        expect(property_paid.lots.first).to be_paid
      end
      it 'property_unpaid has one, unpaid lot' do
        expect(property_unpaid.lots.size).to eql(1)
        expect(property_unpaid.lots.first).to_not be_paid
      end
      it 'property_unpaid has one of each (paid/unpaid) lot' do
        expect(property_mixed.lots.size).to eql(2)
        expect(property_mixed.lots.first).to be_paid
        expect(property_mixed.lots.last).to_not be_paid
      end
    end

    describe 'lot_fees_paid' do
      it 'returns only properties with all lots paid' do
        expect(subject.lot_fees_paid).to contain_exactly(property_paid)
      end
    end

    describe 'lot_fees_paid' do
      it 'returns all properties with at least one lot fee NOT paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(property_mixed, property_unpaid)
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
end
