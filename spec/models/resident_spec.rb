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

  describe '(instance methods)' do
    subject(:resident) { FactoryBot.build(:resident) }

    describe '(validations)' do
      # SKIP: non-numberic chars are removed
      # it 'ensures phone is JUST numbers' do
      #   resident.phone = '1234567890'
      #   expect(resident).to be_valid
      #   resident.phone = '123-456-7890'
      #   expect(resident).to_not be_valid
      #   expect(resident.errors[:phone]).to contain_exactly(/only allows numbers/)
      # end
    end

    describe '#phone' do
      it 'removes all non-number chars' do
        subject.phone = '(555) 443-1212'
        expect(subject.phone).to eql('5554431212')
      end
    end
  end
end
