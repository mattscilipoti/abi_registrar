require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Lot, type: :model do
  describe 'class methods' do
    subject { described_class }

    let(:lot_paid1) { FactoryBot.create(:lot, :paid, lot_number: 'PAID1') }
    let(:lot_paid2) { FactoryBot.create(:lot, :paid, lot_number: 'PAID2') }
    let(:lot_unpaid1) { FactoryBot.create(:lot, lot_number: 'UnP1') }
    let(:lot_unpaid2) { FactoryBot.create(:lot, lot_number: 'UnP2') }

    describe 'lot_fees_paid' do
      it 'returns all lots that are paid' do
        expect(subject.lot_fees_paid).to contain_exactly(lot_paid1, lot_paid2)
      end
    end

    describe 'lot_fees_not_paid' do
      it 'returns all lots that are NOT paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(lot_unpaid1, lot_unpaid2)
      end
    end
  end
end
