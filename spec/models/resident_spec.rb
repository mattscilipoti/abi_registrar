require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Resident, type: :model do
  describe 'class methods' do
    subject { described_class }

    let(:property_mixed) { FactoryBot.create(:property, :with_paid_lots, :with_unpaid_lots, street_name: "MIXED") }
    let(:property_paid) { FactoryBot.create(:property, :with_paid_lots, street_name: "PAID") }
    let(:property_unpaid) { FactoryBot.create(:property, :with_unpaid_lots, street_name: "UNPAID") }
    let!(:resident_mixed1) { FactoryBot.create(:resident, last_name: 'MIXED1', properties: [property_paid, property_unpaid]) }
    let!(:resident_mixed2) { FactoryBot.create(:resident, last_name: 'MIXED2', properties: [property_paid, property_mixed]) }
    let!(:resident_paid) { FactoryBot.create(:resident, last_name: 'PAID', properties: [property_paid]) }
    let!(:resident_unpaid) { FactoryBot.create(:resident, last_name: 'UNPAID', properties: [property_unpaid]) }

    describe 'lot_fees_paid' do
      it 'returns only residents who paid lot fees for ALL their properties' do
        expect(subject.lot_fees_paid).to contain_exactly(resident_paid)
      end
    end

    describe 'lot_fees_not_paid' do
      it 'returns any property where some lot fee is not paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(resident_unpaid, resident_mixed1, resident_mixed2)
      end
    end
  end
end
