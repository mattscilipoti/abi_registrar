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

  describe ('instance methods') do
    subject(:lot) { FactoryBot.create(:lot) }
    describe '#tax_identifier' do
      it 'pads the district (00)' do
        lot.district = 2
        expect(lot.tax_identifier).to start_with('02 ')
      end

      it 'pads the subdivision (000)' do
        lot.district = 2
        lot.subdivision = 4
        expect(lot.tax_identifier).to start_with('02 004')
      end

      it 'pads the account number (0*8)' do
        lot.account_number = 123456
        expect(lot.tax_identifier).to end_with(' 00123456')
      end
    end
  end
end
