require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Property, type: :model do
  describe 'class methods' do
    subject { described_class }

    let(:lot_paid) { FactoryBot.create(:lot, :paid, lot_number: 'PAID') }
    let(:lot_unpaid) { FactoryBot.create(:lot, lot_number: 'UnP') }
    let!(:property_mixed) { FactoryBot.create(:property, lots: [lot_paid, lot_unpaid], street_name: "MIXED") }
    let!(:property_paid) { FactoryBot.create(:property, lots: [lot_paid], street_name: "PAID") }
    let!(:property_unpaid) { FactoryBot.create(:property, lots: [lot_unpaid], street_name: "UNPAID") }
    
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
