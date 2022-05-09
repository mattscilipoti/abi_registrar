require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Property, type: :model do
  describe 'class methods' do
    subject { described_class }

    describe 'lot_fees_paid' do
      let(:lot_paid) { FactoryBot.create(:lot, :paid) }
      let(:lot_unpaid) { FactoryBot.create(:lot) }
      let!(:property_mixed) { FactoryBot.create(:property, lots: [lot_paid, lot_unpaid]) }
      let!(:property_paid) { FactoryBot.create(:property, lots: [lot_paid]) }
      let!(:property_unpaid) { FactoryBot.create(:property, lots: [lot_unpaid]) }

      it 'returns only properties with all lots paid' do
        expect(subject.lot_fees_paid).to contain_exactly(property_paid)
      end
    end
  end
end
