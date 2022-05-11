require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe ItemTransaction, type: :model do
  describe 'class methods' do
    subject { described_class }

    describe 'search_by_all' do
      let(:lot_paid) { FactoryBot.create(:lot, :paid) }
      # let(:lot_unpaid) { FactoryBot.create(:lot) }
      let(:property_123) { FactoryBot.create(:property, street_number: 123, lots: [lot_paid]) }
      let(:property_456) { FactoryBot.create(:property, street_number: 456, lots: [lot_paid]) }

      let(:resident_a) { FactoryBot.create(:resident, last_name: 'LastNameA') }
      let(:resident_b) { FactoryBot.create(:resident, last_name: 'LastNameB') }

      let!(:residency_a) { FactoryBot.create(:residency, :deed_holder, resident: resident_a, property: property_123) }
      let!(:residency_b) { FactoryBot.create(:residency, :deed_holder, resident: resident_b, property: property_456) }

      let!(:transaction_1) { FactoryBot.create(:share_transaction, activity: :purchase, residency: residency_a) }
      let!(:transaction_2) { FactoryBot.create(:share_transaction, activity: :purchase, residency: residency_b) }
      let!(:transaction_3) { FactoryBot.create(:share_transaction, activity: :transfer, quantity: 1, residency: residency_b, from_residency: residency_a) }

      it "returns transaction_1 & 2, when query=='purchase'" do
        expect(subject.search_by_all('purchase')).to contain_exactly(transaction_1, transaction_2)
      end

      it "returns transaction_3, when query=='transfer'" do
        expect(subject.search_by_all('transfer')).to contain_exactly(transaction_3)
      end

      it "returns transaction_2&3, when query=='456', for street_number" do
        expect(subject.search_by_all('456')).to contain_exactly(transaction_2, transaction_3)
      end

      it "returns transaction_1&3, when query=='123', for street_number" do
        expect(subject.search_by_all('123')).to contain_exactly(transaction_1, transaction_3)
      end

      it "returns transaction_1&3, when query=='LastNameA', for street_number" do
        expect(subject.search_by_all('LastNameA')).to contain_exactly(transaction_1, transaction_3)
      end

      it "returns transaction_2&3, when query=='LastNameB', for street_number" do
        expect(subject.search_by_all('LastNameB')).to contain_exactly(transaction_2, transaction_3)
      end
    end
  end
end
