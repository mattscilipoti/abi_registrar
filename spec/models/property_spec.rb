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
end
