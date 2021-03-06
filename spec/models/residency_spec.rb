require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe Residency, type: :model do
  describe 'class methods' do
    subject { described_class }

    let(:property_mixed) { FactoryBot.create(:property, :with_paid_lots, :with_unpaid_lots, street_name: "MIXED") }
    let(:property_paid) { FactoryBot.create(:property, :with_paid_lots, street_name: "PAID") }
    let(:property_unpaid) { FactoryBot.create(:property, :with_unpaid_lots, street_name: "UNPAID") }
    let!(:residency_mixed) { FactoryBot.create(:residency, property: property_mixed) }
    let!(:residency_paid) { FactoryBot.create(:residency, property: property_paid) }
    let!(:residency_unpaid) { FactoryBot.create(:residency, property: property_unpaid) }

    describe 'lot_fees_paid' do
      it 'returns only properties with all lots paid' do
        expect(subject.lot_fees_paid).to contain_exactly(residency_paid)
      end
    end

    describe 'lot_fees_not_paid' do
      it 'returns properties with at least one lot fee NOT paid' do
        expect(subject.lot_fees_not_paid).to contain_exactly(residency_mixed, residency_unpaid)
      end
    end
  end

  describe '(validations)' do
    it 'each Property can only have one Owner' do
      r = FactoryBot.create(:residency, :owner)
      expect(r).to be_valid

      expect {
        FactoryBot.create(:residency, :owner, property: r.property)
      }.to raise_error ActiveRecord::RecordInvalid, /Validation.*one Owner/
    end

    it 'each Resident can only have one Residence' do
      r = FactoryBot.create(:residency)
      expect(r).to be_valid
      expect(r).to be_primary_residence

      expect {
        FactoryBot.create(:residency, resident: r.resident)
      }.to raise_error ActiveRecord::RecordInvalid, /Validation.*one Residence/
    end
  end
end
