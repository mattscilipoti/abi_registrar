require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    let(:lot_paid) { FactoryBot.create(:lot, :paid) }
    let(:lot_unpaid) { FactoryBot.create(:lot) }
    let(:property_mixed) { FactoryBot.create(:property, street_name: "MIXED", lots: [lot_paid, lot_unpaid]) }
    let(:property_paid) { FactoryBot.create(:property, street_name: "PAID", lots: [lot_paid]) }
    let(:property_unpaid) { FactoryBot.create(:property, street_name: "UNPAID", lots: [lot_unpaid]) }
    let!(:resident_mixed) { FactoryBot.create(:resident, last_name: 'MIXED', properties: [property_paid, property_unpaid]) }
    let!(:resident_paid) { FactoryBot.create(:resident, last_name: 'PAID', properties: [property_paid]) }
    let!(:resident_unpaid) { FactoryBot.create(:resident, last_name: 'UNPAID', properties: [property_unpaid]) }

    describe 'lot_fees_paid' do
      it 'returns only residents hwo paid lot fees for ALL their properties' do
        expect(subject.lot_fees_paid).to contain_exactly(resident_paid)
      end
    end

    describe 'lot_fees_not_paid' do
      it 'returns any property where some lot fee is not paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(resident_unpaid, resident_mixed)
      end
    end
  end
end
